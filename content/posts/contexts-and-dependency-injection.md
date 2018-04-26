+++
date = "2016-07-25T18:31:27-07:00"
summary = "An examination of different dependency injection strategies in Go."
title = "Contexts & Dependency Injection"
url = "/posts/contexts-and-dependency-injection"
+++

Just before GopherCon, Peter Bourgon was tweeting about contexts and dependency injection. For background, Peter is someone whose best practices have rung true or been proven over time since he started talking about them (to my knowledge) at the first GopherCon. So when he [said](https://twitter.com/peterbourgon/status/752022730812317696) not to use [contexts](https://golang.org/x/net/context) as a way to manage dependency injection, I was pretty sad. That’s typically how I handle dependency injection.

(While I was working on this post, Peter [published his own](https://peter.bourgon.org/blog/2016/07/11/context.html), which is significantly more succinct, but also focused a bit differently than this one. I suggest checking it out.)

But I’m getting ahead of myself. Let’s back up and talk about dependency injection in Go more holistically.

## The (Global, Mutable) Dark Days

To tell this story properly, we need to travel all the way back to when I was learning Go, in 2012. In those dark days, I was pretty happy to just declare a variable, hoist it to a global variable, and then reference that variable wherever I needed my dependency.

```go
package main

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	db = myDB
	count, err := getCount()
	if err != nil {
		panic(err)
	}
	fmt.Println("There are", count, "gophers")
}

func getCount() (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}
```

And everything was rainbows and sunshine. And then Gustavo Niemeyer [pointed out](https://groups.google.com/d/topic/mgo-users/idqcsLtq6FA/discussion) that I was making my life hard when it comes to testing. How am I supposed to test `getCount`? I have to stand up a MySQL database, then muck about with it. And I can’t have parallel tests, because `COUNT(*)` works on the entire table, and I can only specify a single database. So I can’t give my tests their own namespace, so I can’t have parallel tests. Parallel tests are nice. I’d like to be able to use them.

## For The Sake Of Argument(s)

Gustavo’s suggestion to me was that I simply pass my database connection (well, mgo session, but let’s stick to database connections to make this easy) as an argument to the functions that need it. And that’s fair, and simple, and [I like simple things]({{< ref "posts/cleverness.md" >}}), so let’s give that a shot.

```go
package main

import (
	"database/sql"
	"fmt"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	count, err := getCount(myDB)
	if err != nil {
		panic(err)
	}
	fmt.Println("There are", count, "gophers")
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}
```

That’s much better! We can use one database for each test, and run them in parallel. If we use an interface, we could stub out that database for tests, and just pass in the stub. Hooray, problem solved!

## Handling Handlers

I like to describe my job as “wrangling state and formatting strings”, because that’s mostly what developing web servers is. At least, in my experience. As a backend developer for the web, there’s one function signature that, were I a tattoo person, I’d absolutely have tattooed somewhere:

```go
func(w http.ResponseWriter, r *http.Request)
```

That’s how you write an HTTP handler in Go, and it’s the entry point for any HTTP endpoint in your Go programs. (Unless you’re doing weird stuff with servers, I guess?) But there’s a problem… Where do I put my database connection now? I don’t get to pick my function signature anymore, I have to work within the constraints I’m given.

We _could_ use a wrapper to modify the function signature but still be an `http.Handler`:

```go
package main

import (
	"database/sql"
	"net/http"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here") 
	if err != nil {
		panic(err)
	}
	http.Handle("/", wrapDB(myDB, handler))
	// ListenAndServe, you know the rest
}

func handler(w http.ResponseWriter, r *http.Request, db *sql.DB) {
	count, err := getCount(db)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Write([]byte(strconv.Itoa(count) + " gophers"))
}

func wrapDB(db *sql.DB, next func(w http.ResponseWriter, r *http.Request, db *sql.DB)) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		next(w, r, db)
	})
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}
```

And that seems to be fine, right? Everything is great. Except we don’t need to embed a database. We need a database, and a logger, and a metrics collector, and a client for another HTTP service, and a…

## Adding Some Context

Fortunately, There’s A Package For That. The [context](https://golang.org/x/net/context) package, mentioned in our opening, gives us a `Context` type. The `Context` type has [some concurrency tooling](https://blog.golang.org/context) it provides, but what we’re interested in right now is its ability to embed a value. The `Context` type can act as a map, letting us assign values to keys. (There’s a bit more to this, but it’s not really material right now.)

This is useful, because now we can use our wrapper paradigm from earlier:

```go
package main

import (
	"database/sql"
	"net/http"
	"strconv"

	"golang.org/x/net/context"

	_ "github.com/go-sql-driver/mysql"
)

const (
	dbKey = "mydb" // don’t use a string here, but that’s another blog post…
)

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	ctx := context.WithValue(context.Background(), dbKey, myDB)
	http.Handle("/", wrapContext(ctx, handler))
	// ListenAndServe, you know the rest
}

func handler(ctx context.Context, w http.ResponseWriter, r *http.Request) {
	val := ctx.Value(dbKey)
	if val == nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	db, ok := val.(*sql.DB)
	if !ok {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	count, err := getCount(db)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Write([]byte(strconv.Itoa(count) + " gophers"))
}

func wrapContext(ctx context.Context, next func(ctx context.Context, w http.ResponseWriter, r *http.Request)) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		handler(ctx, w, r)
	})
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}

```

We reuse the idea of wrapping, but everything gets bundled in the `context.Context`, and pulled out of it from inside the `http.Handler`. Perfect! This is going great.

## Reusable Middleware

Unfortunately, we have a problem now. Our handler works fine, but if we want to take advantage of any middleware for our request, we’re going to have a bad time of it.

_Quick aside: if you’re not familiar with middleware, I recommend [this post](https://justinas.org/writing-http-middleware-in-go/) from Justinas Stankevičius._

The thing about middleware is that the Go community has come to consider the `http.Handler` type sacred. If you’re not accepting and returning an `http.Handler` type in your middleware, it’s probably not getting very popular. Additionally, if you can’t use middleware that accepts and returns an `http.Handler`, you’re probably going to miss out on most the community-provided middleware available.

You’ll notice we’re returning an `http.Handler` above. So we _can_ use the community-provided middleware, but there’s a catch: we now have two types of middleware. The `http.Handler` interface accepts an `http.Handler` and returns an `http.Handler`, and doesn’t get to use any of the information in the `Context`. Then our internal middleware can accept our `Context` as part of its function signature (so `func(ctx context.Context, w http.ResponseWriter, r *http.Request)`) and gets to take advantage of the values within. The general structure is:

Request Muxer -> `http.Handler` middleware -> `wrapContext` -> `Context` middleware -> `Context`-aware handler

This is not ideal, but it _does_ work. It’s what I currently am doing in my projects, and my life has been worse.

## Go 1.7 To The Rescue

So when I heard [Go 1.7 embeds a Context in `http.Request`](https://tip.golang.org/pkg/net/http/#Request.Context), I was very excited. Good-bye `wrapContext`, good-bye artificial division between my middlewares. I can now arrange my middleware in any way I like. I’ll just embed my database-aware `Context` inside the `*http.Request` and suddenly I’ll be back to that magic function signature: `func(w http.ResponseWriter, r *http.Request)`. This is _so great_. We _can_ have nice things. Good job everyone, we can all take tomorrow off.

Except, wait, hang on. How are we going to inject those variables into the `*http.Request` type’s `Context`? We can’t do it in `main` anymore, because we don’t have the `*http.Request` instance yet. Hrm.

OK, time for another ugly wrapper:

```go
package main

import (
	"context"
	"database/sql"
	"net/http"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

const (
	dbKey = "mydb" // don’t use a string here, but that’s another blog post…
)

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	ctx := context.WithValue(context.Background(), dbKey, myDB)
	http.Handle("/", wrapContext(ctx, handler))
	// ListenAndServe, you know the rest
}

func handler(ctx context.Context, w http.ResponseWriter, r *http.Request) {
	val := ctx.Value(dbKey)
	if val == nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	db, ok := val.(*sql.DB)
	if !ok {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	count, err := getCount(db)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Write([]byte(strconv.Itoa(count) + " gophers"))
}

func wrapContext(ctx context.Context, next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		r = r.WithContext(ctx)
		next.ServeHTTP(w, r)
	})
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}
```

Well, ok, so we still have to use a wrapper, but it’s a pretty straightforward piece of middleware. And we now get to use middleware in whatever order our code requires. This is okay. We can live with this.

But we’ve got a new problem. (_Of course_ we have a new problem.) Remember when I said the `Context` type had some concurrency tooling? Yeah, that stuff is going to come back to bite us now. We just broke the `*http.Request`’s `Context` cancellation and deadline semantics.

> For incoming server requests, the context is canceled when the ServeHTTP method returns.

That’s a nice piece of the docs for [`*http.Request#Context()`](https://tip.golang.org/pkg/net/http/#Request.Context), and it’s basically telling us our `Context` will be canceled after every request. Which sounds fine, right? It is, when each `*http.Request` has its own `Context`. But our wrapper above is replacing each `*http.Request`’s `Context` with a copy of a _shared_ `Context` instance. And when a `Context` is canceled, the resources associated with it are released. So if we’re still using it… that sounds bad?

Oh, and also the docs say this about `Context`s:

> Incoming requests to a server should create a Context, and outgoing calls to servers should accept a Context. The chain of function calls between them must propagate the Context, optionally replacing it with a derived Context created using WithCancel, WithDeadline, WithTimeout, or WithValue.

You’ll notice the `Context` we’re injecting in the `*http.Request` wasn’t derived from the `Context` in the `*http.Request`. Oops. So we’re breaking this (probably really important?) assumption.

## Peter Steps In

There are ways to fix these problems: rather than injecting a new `Context` in our middleware, we just need a middleware that injects our dependencies into the existing `*http.Request`. Which is annoying, but we can make it simple.

But this is where Peter shows up in my timeline, so we’re not going to explore that. We’ve spent all this time establishing why `Context` is a great solution and what it offers for us, now let’s start exploring the points Peter’s bringing in that explain why this is The Worst and You Shouldn’t Do It. As I said at the beginning, Peter has a really strong track record of predicting the things that will bite me before I’m bitten, so when he says “don’t do this, you’ll be sad”, I pay attention.

So let’s talk about why this latest solution I’ve found isn’t a solution, but a sad-maker in waiting.

## Tell Me What You Need

If I understand correctly, Peter’s core argument is that by embedding your dependencies (the database connection, the logger, the metrics client, your service clients, etc.) in the `Context`, you’re obscuring them, and it’s no longer obvious what your function depends on.

And, I mean, he’s right… but so what?

The rest of our conversation broke down into essentially two portions:

1. How important is it that your function makes its dependencies clear?
2. What other options do we have?

There was also some talk in there about testability, but I never really wrapped my head around what Peter was getting at, so I’m not going to attempt to address that. But Peter is nice, and patient about explaining things, so if you’re interested, I’d ask him. But [read the conversation I already had with him about it](https://storify.com/paddyforan/contexts-and-dependency-injection), first, so you don’t ask the poor guy to retread the same ground over and over.

## I Clearly Need You

So let’s address that first question. How important is it that your function makes its dependencies clear?

And this question, in itself, really has two parts: how important is it that the dependencies are clear, and how important is it that their _types_ are clear?

That second one is the most clear-cut, objective downfall of `Context`s. The key and value you define in your `Context` are `interface{}` types, meaning we’re taking an escape hatch out of the type system, and the compiler washes its hands of us. It will not help us if we’re using the wrong types, we’ll just blow up at runtime. That is, no matter who you ask, worse than blowing up when you try to build your package.

How important it is that your dependencies are clear is a harder question to talk about. There’s more nuance there, more squishy things it’s hard to measure and reason about.

What we really boiled it down to, from what I can tell, is how approachable your code base is. And Peter is definitely more an expert on this than I am: he works with more people than I do.

And I want to dig into this a bit, because it’s something I’ve been contemplating a lot recently at work. My codebases have a lot of ideas in them and patterns that I use, and once you understand them, the codebase is really easy to navigate and understand. But how do I surface that information to people new to the codebase?

According to Peter, part of that is the function signatures. And after thinking about that a bit, I’m inclined to agree with him. By removing the black hole the `Context` represents for our dependencies (they go in, magic happens, they come out), it makes it easier for people to trace the flow of information throughout the program.

It also makes it easier to modify the program. You only need to fill the function signature, you don’t need to have this other knowledge that other stuff is needed, and where the list of that stuff resides. There’s less reliance on convention and documentation, which is a preferable state of affairs.

## What Else Is There?

So we’ve established that, all else equal, it’s better to explicitly list your dependencies as function params. But all else isn’t equal. We’ve spilled a lot of pixels already talking about why things aren’t equal. Can we retain the benefits we got from the `Context` but without the black hole approach to dependency injection?

Peter’s first suggestion is to abuse closures to inject the variable into a handler, like we did to wrap our `Context` before:

```go
package main

import (
	"database/sql"
	"net/http"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	http.Handle("/", handler(myDB))
	// ListenAndServe, you know the rest
}

func handler(db *sql.DB) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		count, err := getCount(db)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		w.Write([]byte(strconv.Itoa(count) + " gophers"))
	})
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}

```

Here we’re using closures to inject the database connection into our handler function. This works, it fits the criteria above, but I find it annoying because (in my opinion) it obscures what the handler is actually doing, by hiding it amongst the tomfoolery to get the database connection injected into our scope.

It also does not make the connection available to any of our middleware, but Peter has a solution for that: just inject the connection into the middleware.

```go
package main

import (
	"database/sql"
	"net/http"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	http.Handle("/", minGophers(myDB)(handler(myDB)))
	// ListenAndServe, you know the rest
}

func minGophers(db *sql.DB) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// call our handler only if there are more than 5 gophers
			count, err := getCount(db)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				return
			}
			if count < 5 {
				w.WriteHeader(http.StatusBadRequest)
				w.Write([]byte("Error: not enough gophers"))
				return
			}
			next.ServeHTTP(w, r)
		})
	}
}

func handler(db *sql.DB) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		count, err := getCount(db)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		w.Write([]byte(strconv.Itoa(count) + " gophers"))
	})
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}
```

But looking at that `http.Handle` line, I can already feel the repetition coming. I’ll have five pieces of middleware, injecting the log five times. And the metrics. The `http.Handle` line starts getting really complicated and looks like magic and then nobody wants to touch it and it becomes unclear what arguments belong to which function and we’re not in a much better place than we are with `Context`s.

It works, but I don’t like it. It looks uncomfortably similar to a magic incantation at first glance. Can we do better?

## Add a Little Struct(ure)

So, ok, we keep coming back to “I have more than one thing I need to be passing around”, but we can solve that. Let’s just bundle them up in a struct. Still type-safe, still easy to discover, no big deal:

```go
package main

import (
	"database/sql"
	"net/http"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

type Deps struct {
	Database *sql.DB
	// also logging
	// and metrics
	// and service consumers
	// whatever
}

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	deps := Deps{Database: myDB}
	http.Handle("/", minGophers(deps)(handler(deps)))
	// ListenAndServe, you know the rest
}

func minGophers(deps Deps) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// call our handler only if there are more than 5 gophers
			count, err := getCount(deps.Database)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				return
			}
			if count < 5 {
				w.WriteHeader(http.StatusBadRequest)
				w.Write([]byte("Error: not enough gophers"))
				return
			}
			next.ServeHTTP(w, r)
		})
	}
}

func handler(deps Deps) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		count, err := getCount(deps.Database)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		w.Write([]byte(strconv.Itoa(count) + " gophers"))
	})
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}
```

That’s at least _better_. We no longer have to worry about 5 different dependencies polluting our function signatures, obscuring what’s going on in our `http.Handle` line. We also don’t need to edit every single `http.Handle` call to add a logger, or telemetry client, or what have you.

But wait, if we’re just including a struct as the first parameter of a function, that reminds me of a language feature…

## A Better Method

Methods, I’ve been led to understand, are equivalent to a function with the receiver as the first parameter. So `func (a *MyType) Hello(world string)` is equivalent to `func Hello(a *MyType, world string)`. But–and this is important–the function signature doesn’t actually include the receiver. So `func (a *MyType) HandleFoo(w http.ResponseWriter, r *http.Request)` actually fills our `http.HandlerFunc` function signature. You can probably guess where I’m going with this.

```go
package main

import (
	"database/sql"
	"net/http"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

type APIv1 struct {
	Database *sql.DB
	// also logging
	// and metrics
	// and service consumers
	// whatever
}

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	apiv1 := APIv1{Database: myDB}
	http.HandleFunc("/", apiv1.handler)
	// ListenAndServe, you know the rest
}

func (a APIv1) handler(w http.ResponseWriter, r *http.Request) {
	count, err := getCount(a.Database)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Write([]byte(strconv.Itoa(count) + " gophers"))
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}

```

This is nice. This works well, our `http.Handle` call is clear as day, we can track the dependencies easily (you need an `APIv1` struct!), we have type safety, we can use middleware… everything is great.

## Concerns About Separating

There’s one last thing bugging me, and then I’ll be happy with Peter’s advice. To understand it, we need to talk about how I tend to structure projects.

Each project usually gets, at the repo root, the business logic for my application. This means, basically, state management, and a few helpers around other common things. I then have a subpackage for each version of the API; you’ll see `apiv1`, `apiv2`, etc. That way, each binary can have multiple versions of the API running at once.

The reason this is important is because of that struct containing our dependencies. It begs the question: which package does that struct live in?

The obvious answer is, of course, to put it in that root package, the one that owns the state manipulation and common helpers. This is, after all, essentially a common helper. But that package almost never has any knowledge of authorization or authentication, by design. So when I need to contact a service over HTTP to do authorization or authentication, I need to introduce that dependency into the dependencies struct, even though it’s not _really_ a dependency in that root package. Consider also that the authorization and authentication mechanisms may vary between separate versions of the API, and it’s easy to see how the struct gets to be bloated. It feels like we can do better, there.

The next thought is to make it live in the API packages, but that also is problematic. It cuts off our root package from logging and metrics, and turns it into a black hole in terms of debugging for our application. Not good.

We could separate it out into its own package, that both the APIs and the root package import, but we still have the problem of bloat and conflating dependencies. And that’s really the heart of the issue here: we’re trying to manage a single set of dependencies, but the way we’ve laid out our project and are conceiving of it really calls for multiple, overlapping sets of dependencies.

## Composing Ourselves

The tentative solution I’m playing with, but haven’t really done enough with to recommend to others (yet) is to use composition; it seems well-suited to this problem. So we may have a `Dependencies` struct in the root package holding the common dependencies for our root package (our logger, our metrics handle, our database connection), and an `APIv1` struct in our `apiv1` package, holding the common dependencies for that version of the API (authorization and authentication clients) and embedding the `Dependencies` struct from our root package. Handlers then get defined on the `APIv1` struct, and get access to all root package dependencies through type composition.

Middleware is still an issue; developing shared middleware becomes tough, as we have no convenient way to make dependencies available in a type-safe way, and middleware can no longer opportunistically take advantage of any dependencies it can manage to detect, like we could with `context.Context`. But we _can_ agree to a few methods to expose the important stuff, and use interfaces to achieve type-safety and reusability in multiple projects:

```go
package main

import (
	"database/sql"
	"net/http"
	"os"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

type Dependencies struct {
	Database *sql.DB
	// also logging
	// and metrics
	// and service consumers
	// whatever
}

func (d Dependencies) GetDatabase() *sql.DB {
	return d.Database
}

// this would be in the apiv1 package, but for illustration purposes…
type APIv1 struct {
	Dependencies
	// any APIv1-specific dependencies
}

type Databaser interface {
	GetDatabase() *sql.DB
}

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	coreDeps := Dependencies{Database: myDB}
	apiv1 := APIv1{Dependencies: coreDeps}
	http.Handle("/", minGophersMiddleware(coreDeps, http.HandlerFunc(apiv1.handler)))
	// ListenAndServe, you know the rest
}

func minGophersMiddleware(d Databaser, next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// call our handler only if there are more than 5 gophers
		db := d.GetDatabase()
		count, err := getCount(db)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		if count < 5 {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte("Error: not enough gophers"))
			return
		}
		next.ServeHTTP(w, r)
	})
}

func (a APIv1) handler(w http.ResponseWriter, r *http.Request) {
	count, err := getCount(a.Database)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Write([]byte(strconv.Itoa(count) + " gophers"))
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}

```

It’s still doesn’t hide the cruft as nicely as the `context` solution did, but I think hiding the cruft was a good portion of the objection to it, in the first place. We’re less interested in hiding it here than we are in managing it, and making sure it doesn’t overpower and obscure, but is still easily discoverable. This is about tidying things up, not magicking them away.

That `http.Handle` line still looks pretty gnarly; a good solution may be to (as I prefer to) have all the muxing for a specific API version handled in its package, then just send requests based on their prefix to that version’s router. If we do that, we can define it in a `ServeHTTP` method on the `APIv1` type, which means we don't need to cast to `http.HandlerFunc` in the `http.Handle` line, cleaning it up a bit:

```go
package main

import (
	"database/sql"
	"net/http"
	"strconv"

	_ "github.com/go-sql-driver/mysql"
)

type Dependencies struct {
	Database *sql.DB
	// also logging
	// and metrics
	// and service consumers
	// whatever
}

func (d Dependencies) GetDatabase() *sql.DB {
	return d.Database
}

type APIv1 struct {
	Dependencies
	// any APIv1-specific dependencies
}

type Databaser interface {
	GetDatabase() *sql.DB
}

func main() {
	myDB, err := sql.Open("mysql", "mysql-dsn-goes-here")
	if err != nil {
		panic(err)
	}
	coreDeps := Dependencies{Database: myDB}
	apiv1 := APIv1{Dependencies: coreDeps}
	http.Handle("/v1", apiv1)
	// ListenAndServe, you know the rest
}

func minGophersMiddleware(d Databaser, next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		// call our handler only if there are more than 5 gophers
		db := d.GetDatabase()
		count, err := getCount(db)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			return
		}
		if count < 5 {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte("Error: not enough gophers"))
			return
		}
		next.ServeHTTP(w, r)
	})
}

func (a APIv1) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// use a router package here
	// in this example we’re just gonna respond with the same
	// handler to every request
	minGophersMiddleware(a.Dependencies, http.HandlerFunc(a.handler)).ServeHTTP(w, r)
}

func (a APIv1) handler(w http.ResponseWriter, r *http.Request) {
	count, err := getCount(a.Database)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	w.Write([]byte(strconv.Itoa(count) + " gophers"))
}

func getCount(db *sql.DB) (int, error) {
	var count int
	err := db.QueryRow("SELECT COUNT(*) FROM animals WHERE name=?", "gopher").Scan(&count)
	return count, err
}
```

That `ServeHTTP` function looks a bit gnarly, but it looks much better if you use a router package.

## Can We Do Better?

This is where I am in my dependency injection story, at the moment. I’m interested in knowing where you all are. If you have a way you like better, or see a flaw in my approach, let me know. Hit me up on [Twitter](https://twitter.com/paddycarver), or ping me on the [Gophers Slack](https://bit.ly/go-slack-signup) (my username there is paddy).

Thanks to Peter for talking through a lot of this with me and sharing his best practices.

Extra big thank you to [Margaret Staples](https://deadlugosi.blogspot.com) and [Chris Agocs](https://agocs.org) for giving me feedback and thoughts on earlier drafts of this post.
