+++
date = "2015-07-02"
summary = "Part one of an ongoing series about using Ampersand.js with OAuth2. We’ll talk about storing your tokens and their associated metadata."
title = "Ampersand & OAuth2, Part 1: Local Storage"
url = "/posts/ampersand-oauth-cache"
+++


We’re going to try something new today. We’re going to remember I’m a developer, and I’m going to post some code on my blog, and we’ll all just see how that works out, ok? To kick it off, I’m gonna do a small series on using [Ampersand.js](http://ampersandjs.com) as the front end for an API that uses OAuth2 for the authentication. In this post, we’re going to cover storing, loading, and maintaining the tokens and their metadata.

So let’s get to it.

## Our Setup

I’m going to assume that you’re using [`ampersand-app`](https://github.com/ampersandjs/ampersand-app) and [`ampersand-model`](https://github.com/ampersandjs/ampersand-model). If you’re not, just move along, this article will very likely be useless to you. I’m also going to assume you’re using an ES6 transpiler, like [Babel](http://babeljs.io). Because, well, I am. And it’s nice. So we’re going to, just this once, have nice things.

Our problem (today) is, once we get the user authenticated, we need to keep track of their OAuth access token and refresh token. If we lose them, the user has to re-authenticate, and that’s not a fun user experience. So we want to avoid that.

Fortunately, someone [smarter than me](http://learn.humanjavascript.com/react-ampersand/introduction) has [an example](https://github.com/HenrikJoreteg/hubtags.com/blob/47dca17ef9fe58404a7f83b05c65bd01fa3cd268/src/models/me.js) for how to do that using `ampersand-model`. So we’re going to copy Henrik’s “Me” model:

{{< highlight javascript >}}
import Model from 'ampersand-model'

export default Model.extend({
  url: 'https://auth.server/path/to/token/endpoint',
  props: {
    access_token: 'string',
    refresh_token: 'string',
    expires_in: 'int',
    token_created: 'date',
    profileID: 'string',
  },
})
{{< /highlight >}}

So far, so good. We’ve got a basic model with some properties. Nothing earth-shattering here.

We’re going to skip how to go ahead and populate the data. That’s, frankly, boring. (Hint: use [`ampersand-sync`](https://github.com/ampersandjs/ampersand-sync) if you want to get some cool features from the next part of this series.)

For now, we’re just going to assume you get a populated `Me` instance, somehow.

## Storing the Tokens

We want to be able to cache that information in localStorage. The helper to do that is tiny:

{{< highlight javascript >}}
writeToCache () {
  const data = JSON.stringify(this)
  localStorage.setItem('me', data)
}
{{< /highlight >}}

Super silly simple, right? Let’s put it all together to just highlight how silly it is that I’m writing a whole blog post about this:

{{< highlight javascript >}}
import Model from 'ampersand-model'

export default Model.extend({
  url: 'https://auth.server/path/to/token/endpoint',
  props: {
    access_token: 'string',
    refresh_token: 'string',
    expires_in: 'int',
    token_created: 'date',
    profileID: 'string',
  },
  writeToCache () {
    const data = JSON.stringify(this)
    localStorage.setItem('me', data)
  },
})
{{< /highlight >}}

You’ll notice that we’re using `JSON.stringify(this)` instead of `this.toJSON()`. If you check [the docs](https://ampersandjs.com/docs#ampersand-state-tojson), you’ll see that `this.toJSON()` does not, in fact, do what you think it does (emphasis mine):

> Return a shallow copy of the state’s attributes for JSON stringification. This can be used for persistence, serialization, or augmentation, before being sent to the server. **The name of this method is a bit confusing, as it doesn’t actually return a JSON string** — but I’m afraid that it’s the way that the JavaScript API for `JSON.stringify` works.

I draw attention to this because it bit me. The moral of the story is that `this.toJSON()` is a lying liar that lies, and there’s not much the very nice Ampersand folks can do about it.

## Loading the Tokens

Continuing on our journey, however, it occurs to me that if you’re going to store your data, you should probably, at some point, load it. After all, if data is stored in a forest, and no, uh, trees are there to, err, load… you know what, never mind. Point is, saving data and not loading it is rather silly. So let’s write a helper!

{{< highlight javascript >}}
load () {
  const data = localStorage.getItem('me')
  if (data) {
    const loaded = JSON.parse(data)
    this.set(loaded)
  }
  return this
}
{{< /highlight >}}

Super exciting, right? Pull the string out of localStorage, and if it worked, parse the JSON string into a Plain Ol’ JavaScript Object. Once that’s done, use it to update the `Me` model with [`set`](https://ampersandjs.com/docs#ampersand-state-set).

So to keep our running sample all together:

{{< highlight javascript >}}
import Model from 'ampersand-model'

export default Model.extend({
  url: 'https://auth.server/path/to/token/endpoint',
  props: {
    access_token: 'string',
    refresh_token: 'string',
    expires_in: 'int',
    token_created: 'date',
    profileID: 'string',
  },
  writeToCache () {
    const data = JSON.stringify(this)
    localStorage.setItem('me', data)
  },
  load () {
    const data = localStorage.getItem('me')
    if (data) {
      const loaded = JSON.parse(data)
      this.set(loaded)
    }
    return this
  },
})
{{< /highlight >}}

## Set It & Forget It

We have a helper method to save our tokens to localStorage, but who wants to use that? You have to remember to call it every time your tokens change, they can get out of sync, it just feels like a pain.

I have a better idea.

One of the things we get for free from `ampersand-model` (thanks, `ampersand-model`!) is a set of events that get fired off. One of those events is the `change` event, which gets triggered when an attribute changes.

That sounds super handy. Let’s hook it up!

In your `main.js`, or whatever file is serving as the entrypoint for your app, include this:

{{< highlight javascript >}}
import app from 'ampersand-app'
import Me from './me'

window.app = app.extend({
  init () {
    this.me = new Me()
    this.me.on('change', this.me.writeToCache)
  }
})

app.init()
{{< /highlight >}}

That’s just your basic [`ampersand-app`](https://github.com/ampersandjs/ampersand-app) setup. We’re attaching an instance of your `Me` model to the app singleton, so we can refer to the same instance throughout our application. Then we’re listening for changes to our instance, and calling its `writeToCache` function when changes occur. This means whenever the tokens change, they _automatically_ get persisted to localStorage _for you_. You don’t even have to think about it.

Go ahead, try it. I’ll wait.

But we have some issues. Some things ([`ampersand-sync`](https://github.com/ampersandjs/ampersand-sync) comes to mind…) aren’t very conservative about updating things all at once. Sometimes they update properties one at a time. Which means we’d write to the cache every single time any property changed, instead of trying to batch them. That’s no good. We should obviously be batching these changes to reduce our resource usage.

The trick is to _debounce_ the `writeToCache` function. That just means that the function will only be called once every so often, rolling multiple calls in that time period into a single call. Which sounds like what we want.

Here are the modifications you need:

{{< highlight javascript >}}
import Model from 'ampersand-model'
import debounce from 'lodash.debounce'

export default Model.extend({
  url: 'https://auth.server/path/to/token/endpoint',
  props: {
    access_token: 'string',
    refresh_token: 'string',
    expires_in: 'int',
    token_created: 'date',
    profileID: 'string',
  },
  initialize () {
    this.debouncedWriteToCache = debounce(this.writeToCache, 250)
  },
  writeToCache () {
    const data = JSON.stringify(this)
    localStorage.setItem('me', data)
  },
  load () {
    const data = localStorage.getItem('me')
    if (data) {
      const loaded = JSON.parse(data)
      this.set(loaded)
    }
    return this
  },
})
{{< /highlight >}}

All we did was add an `initialize` function to our `Me` model, and have it set `this.debouncedWriteToCache` to be a debounced version of `writeToCache`, so multiple calls within 250 milliseconds are turned into a single call. There’s no reason we should be modifying our tokens more than once every 250 milliseconds, anyways.

That done, we can update our application bootstrap to use the debounced version:

{{< highlight javascript >}}
import app from 'ampersand-app'
import Me from './me'

window.app = app.extend({
  init () {
    this.me = new Me()
    this.me.on('change', this.me.debouncedWriteToCache)
  }
})

app.init()
{{< /highlight >}}

Now no matter how many properties change, you only write to localStorage once. Hooray!

OK, so we have saving taken care of automatically and we don’t need to think about it anymore. How about loading?

That’s actually phenomenally simple. Ready for this big code change?

{{< highlight javascript >}}
import app from 'ampersand-app'
import Me from './me'

window.app = app.extend({
  init () {
    this.me = new Me().load()
    this.me.on('change', this.me.debouncedWriteToCache)
  }
})

app.init()
{{< /highlight >}}

Yeah, we added `.load()` to the end of our instantiation for `this.me`. Super exciting stuff. It just loads the tokens out of localStorage when your app starts up.

And you’re done! Now your tokens save automatically, get loaded automatically, and you can just treat them like they’re stored in memory _all the time_. No muss, no fuss.

## Paddy, You Just Blogged About Like 40 Lines of Code

This blog post was dealing with an almost ridiculously trivial block of code. There’s nothing fancy in my code samples: I’m setting properties, parsing JSON, and using localStorage.

But the simplicity of the code is _the point_ of this post. Ampersand’s event system let me use 40 lines of code to abstract away what could otherwise be a rather messy part of the application.

And if you stick around for the next post in the series, we’re going to leverage this into truly mind-bending levels of “don’t make me think”.

If you want, for some reason, a running version of this code (along with a transpiler to build it so it functions in your browser), I put it all in a [Github repository](https://github.com/paddyforan/ampersand-oauth-cache). Because the only thing funnier than writing a big long blog post about 40 lines of code is putting it in a Github repo and slapping a license and README on it.
