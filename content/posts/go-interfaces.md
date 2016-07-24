+++
date = "2016-06-11T17:04:58-07:00"
has_tweet = false
summary = "Let’s talk about what makes Go’s interface type so freaking useful."
title = "How I Learned To Quit Worrying And Love Go’s Interfaces"
url = "/posts/go-interfaces"

[quote]
  attr = "[Jesse McNelis](https://groups.google.com/d/msg/golang-nuts/sv-Ol6Aww_w/0538EvVlhe0J)"
  text = "“In Go the primary purpose of methods is to implement interfaces.”"
+++

So [Bill Kennedy](https://www.goinggo.net) and [Nate Finch](https://npf.io) ~~bullied~~ ~~peer-pressured~~ talked me into writing about Go. This post is _all their fault_. I figured I’d start with one of the things I love about Go that took me a while to figure out: Go’s interfaces. So we’re going to tell the story of how Go’s interfaces and I became BFFs, and the critical things I learned that helped that relationship develop.

## At First Blush

My first understanding was simple: interfaces are just duck-typing, right? Cool. Duck-typing is a thing I’ve heard about. Never quite understood what made it so useful, never used it, but it’s nice to know it’s a thing I can do.

From there, I saw the usefulness of the empty interface: `interface{}`. This is just an interface that everything matches. So I can bend the rules of the type system and ok, yeah, I see where that could be useful. The first place I saw it was in the `fmt` package. It’s nice that we can have `fmt.Println` instead of `fmt.StringPrintln` and `fmt.IntPrintln` and so on. That seems useful enough.

## Casual Acquaintances

As I started doing more with Go, I learned about type assertion.

```go
var i interface{}
i = "hello"
str := i.(string)
```

And that was useful-looking. But I was coming from Python, where I would often change the type of something somewhere in my code, then forget to change it elsewhere in my code, and then I’d get an uncaught exception at runtime and everything would blow up and I was _not_ a huge fan of that. And if `i` is somehow not a string in the example above, you get a panic. So this made me nervous. I felt like I was taking very careful aim at my foot.

Then I learned that the “comma OK” pattern was being followed for type assertions. Meaning I can do this:

```go
var i interface{}
i = "world"
str, ok := i.(string)
if !ok {
	fmt.Println("`i` wasn’t a string, you should probably return an error or something")
}
```

And that made me feel a little better. I can have error handling around it! That’s nice. But it still felt a little dangerous. (That’s because it is a little dangerous!)

Then I found [`sort.Interface`](https://golang.org/pkg/sort#Interface), which allowed me to take advantage of the code in the standard library on my own types just by making sure my types have the right method signatures. That’s cool! I can use interfaces as placeholders when I want to get around the type system.

## Becoming Best Friends

At this point, you’ll notice my relationship with interfaces existed entirely around the type system. To me it was a technical feature, not a semantic one.

That subtly started to change when I noticed things like [`io.Writer`](https://golang.org/pkg/io#Writer) and realised it was being used to convey an idea, not to share code. It helped set up a strong demarcation: I don’t care what I’m writing to, my job ends whenever it gets the data it needs.

But at this point, things didn’t really click just yet. It took wanting to use multiple databases with the same business logic before I really got it.

I made storing or retrieving data an interface type:

```go
type Storer interface {
	Store(ctx context.Context, thingToStore Thing) (Thing, error)
	Retrieve(ctx context.Context, idOfThing string) (Thing, error)
}
```

As I wrote, I’d write the business logic and the logic for one database. Then I’d write the logic for the next database. And I’d find that sometimes the API I desired for the business logic meant I was doing validation in the database logic. Which meant that sometimes my two databases would validate things differently, as code drifted. Or I would have each database fill in default values when `Store` gets called, and that meant doing it twice, possibly inconsistently. (That’s why the `Thing` return value exists for the `Store` method above; to send back the values that actually got stored.)

As I wrote more, this became more annoying and more of a headache. It wasn’t working out the way I had hoped. Then I realised I was expecting too much of my interface functions.

I shouldn’t be validating or filling in defaults in my `Store` methods; it was a `Store` method, not a `FillAndValidateAndStore` method. I made it simpler:

```go
type Storer interface {
	Store(ctx context.Context, thingToStore Thing) error
	Retrieve(ctx context.Context, idOfThing string) (Thing, error)
}
```

Suddenly, I knew what my interface was for and what responsibilities it had: its `Store` method needed to persist the data it was given, _exactly_ as it was given the data. If it couldn’t, it needed to return an error. That’s it. That’s its one job. Similarly, `Retrieve` needed to pull the data back out, and that’s it. If it couldn’t, it needed to return an error.

This definition was helpful for testing: to know if I had implemented the interface correctly, I could just store something, retrieve it, then compare whatever I retrieved to what was stored. They should match.

```go
type Thing struct {
	Name string
}

func TestStorer(t *testing.T) {
	storer := someImplementationOfStorer{}
	thing := Thing{Name: "Paddy"}
	err := storer.Store(context.Background(), thing)
	if err != nil {
		t.Errorf("Error storing thing %+v in Storer %T: %+v\n", thing, storer, err)
	}
	retrieved, err := storer.Retrieve(context.Background(), thing.Name)
	if err != nil {
		t.Errorf("Error retrieving thing %s from Storer %T: %+v\n", thing.Name, storer, err)
	}
	if !compareThings(thing, retrieved) {
		t.Errorf("Expected %+v from %T, got %+v\n", thing, storer, retrieved)
	}
}
```

What I didn’t anticipate was how helpful this definition would be for communicating and reasoning about my code. It helped me split things into defined chunks with explicit boundaries and defined responsibilities.

> Interfaces are great for organizing code, not just sharing code.

And this is where I currently am. Interfaces serve as the backbone of my applications, helping to map out where things are and what things are responsible for.

If people are interested, I’ll share some patterns I’ve embraced for interfaces, especially around things like testing. But feel free to reach out on Twitter to tell me how useful or not useful this post was. Bill (and, presumably, Nate) [think more people should blog about Go](https://twitter.com/goinggodotnet/status/740893963020861441), but I don’t really know what to blog about. So… suggestions? Requests?
