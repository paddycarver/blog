+++
title = "Logging the Channel API"
url = "/posts/logging-the-channel-api"
date = 2011-03-29T23:37:00Z
+++

We’re having a bit of an issue at [the 2cloud Project](http://www.2cloudproject.com/). We’re getting reports of the [Channel API](http://code.google.com/appengine/docs/python/channel) throwing [iFrame errors about illegal access](http://help.2cloudproject.com/discussions/problems/51-says-sent-to-cloud-but-never-opens-up-on-chrome). Considering the Channel API is based on Google’s [Closure](http://code.google.com/p/closure-library/) library’s [XPC library](http://closure-library.googlecode.com/svn/!svn/bc/4/trunk/closure/goog/docs/class_goog_net_xpc_CrossPageChannel.html), which uses iFrames, I had a feeling the issue wasn’t on our end. Unfortunately, neither I nor Moishe could figure out why this was happening—we both agreed it shouldn’t be.

Even worse, I didn’t have any logging mechanism for the Channel API at a low level like this, so I couldn’t offer much debug information. The code was minified with Closure’s compiler, which makes debugging it a pain. There’s a wonderful [Closure Inspector](http://code.google.com/p/closure-inspector/) that is supposed to help debug stuff like this, but for some unknown reason, that only runs in Firebug. Which makes debugging a Chrome extension difficult. Clearly, the only thing to be done is to start `console.log`ging things.

It took me far too long to figure out that I couldn’t access Closure logs in Chrome, and it’s annoying to sort through that minified, compiled code to find where the logging is defined. So I’ll just tell you. [Download channel.js]({{< relref "posts/app-engine-channels-and-chrome-extensions.md" >}}), and search for `I.prototype.log`. Remove the following line:

{{< highlight "javascript" >}}if(a.value >= wc(this).value) {{{< /highlight >}}

Being sure to also remove the trailing brace, because you’re intelligent like that. Then, above

{{< highlight "javascript" >}}p.console && p.console.markTimeline && p.console.markTimeline("log:" + a.Xb);{{< /highlight >}}

insert the following:

{{< highlight "javascript" >}}console.log(a.Xb);{{< /highlight >}}

That’s it. enjoy your new, powerful, low-level Channel API logs.

![Log output screenshot](/img/channel_logging.png)

Of course, if you’re not insane and actually plan to debug this, you probably want to [beautify your channel.js file](http://jsbeautifier.org/).
