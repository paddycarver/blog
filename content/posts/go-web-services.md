+++
summary = "How I write web services in Go. A framework for people who don't like frameworks."
url = "/posts/go-web-services"
title = "Writing a Go Web Service"
date = 2019-04-28T17:35:33-07:00
has_tweet = false
draft = true

[quote]
attr = "Person who said it"
text = "“Thing they said.”"

[img]
attr = "Person who took the picture"
file = "file in static/img/posts to use as the picture"
link = "link to the picture if required by rightsholder"
title = "title of picture"
+++

I've been writing Go web services for over seven years now, and in that time,
I've developed a few patterns. But I'm realising I've never written them down
anywhere, so I figured it's time to change that. I'm not going to argue this is
the best or only way to write web services in Go, nor that it will be suited for
everyone, but it's how I like to do it, and it works pretty well for me.

My strategy is optimised for testability, dependency management, working with
the type system, adherence to the standard library, and clarity of code. I've
found these to be good properties to optimise for.

## High Level View

Most my web services end up looking something like this:

```
app
|-- app.go
|-- apiv1
|   |-- app.go
|   |-- endpoints.go
|   |-- handlers.go
|   |-- server.go
|-- cmd
|   |-- appd
|   |   |-- main.go
|   |-- appctl
|   |   |-- main.go
|-- migrations
|   |-- generated.go
|-- sql
|   |-- YYYYMMDD_ORDER_DESCRIPTOR.sql
|-- storers
|   |-- storer.go
|   |-- storers_test.go
|   |-- memory
|   |   |-- memory.go
|   |-- postgres
|   |   |-- postgres.go
|   |   |-- postgres_app.go
|   |   |-- postgres_sql.go
|-- webv1
|   |-- app.go
|   |-- endpoints.go
|   |-- handlers.go
|   |-- server.go
|   |-- assets
|   |   |-- generated.go
|   |-- templates
|   |   |-- index.go.html
|   |   |-- header.go.html
```

This assumes we're working on an app called `app`. I usually give my apps a noun
name, usually the name of the main resource they manage. For example, I may have
a `posts` service, or an `accounts` service.

That first `app.go` contains the core types that define that resource, and the
helpers to interact with those types, and that's about it. The `apiv1` package
contains the `v1` version of the API. We could also have an `apiv2`, `apiv3`,
etc. package, all living side by side. The `cmd` directory doesn't get any code
in it, it just contains packages. Each binary associated with this service gets
a package named for the binary in this directory. The `migrations` directory
contains SQL that has been converted into Go code, no hand-written code ends up
in that directory. The `sql` directory contains a bunch of SQL files to run as
database migrations. The `storers` directory contains a `storer.go` file that
defines what a Storer is, and a `storers_test.go` file that runs tests for all
the storers that are supported, making sure they conform to that definition. It
also contains a package for each storer supported, with the implementation of
that storer living entirely in that package. Finally, a `webv1` package contains
any HTML-rendering code, and like the `apiv1` package, we can have multiple
versions of this side-by-side. It also contains a `templates` directory, filled
with `.go.html` files, and an `assets` package, containing only generated code.

Let's talk about each of those things in more depth, covering the decisions made
in them and why those decisions were made.

## `app.go`

## `apiv1`

### Endpoints

### Handlers

### Resource Types

### Server

## Commands

### `appd`

### `appctl`

## `migrations`

## `sql`

## Storers

### In-Memory

### Postgres

## `webv1`

### Endpoints

### Handlers

### Resource Types

### Server

### Templates
