+++
title = "App Engine Channels and Chrome Extensions"
url = "/posts/app-engine-channels-and-chrome-extensions"
date = 2010-12-08T00:27:00Z
aliaes = ["/posts/app-engine-channels-and-chrome", "/2010/12/app-engine-channels-and-chrome.html"]
+++

Google’s latest toy for [App Engine](http://appengine.google.com/), its [Channel API](http://code.google.com/appengine/docs/python/channel/), is really a cool tool. It gives you Comet support on a _free_ webhost. That’s a phenomenal achievement, in my mind. I was [given early access to it](http://blog.android2cloud.org/2010/08/channel-api.html), to build the [android2cloud](http://code.google.com/p/android2cloud) web server with its technology, to relieve [our polling woes](http://blog.android2cloud.org/2010/08/servers-and-money.html). And I tested it, and it worked great.

And then there were some mishaps, with frontends, and the roll-out to production servers was taking a bit longer than I had hoped, so I had to [look into other alternatives](https://twitter.com/paddyforan/status/27981592770). When an app is eating $80 a week and is [constantly in a state of financial peril](http://blog.android2cloud.org/2010/09/money-spoils-everything-wholesome.html), I couldn’t afford to just rest on my haunches and wait for Google.

And then, of course, Google [got the Channels to production](http://googleappengine.blogspot.com/2010/12/happy-holidays-from-app-engine-team-140.html) before I got my [node.js](http://www.nodejs.org/) implementation to production-readiness. So, of course, I tested the beta software I had written a couple months prior, ensured it still worked, and [called for a test](http://groups.google.com/group/android2cloud-beta/browse_thread/thread/a13caf3450c704c6). Except something blew up in my face: I had neglected to test the extension, trusting that it would still work. It didn’t.

Google had changed their code that handles their "CrossPageChannel"; basically, a hidden, embedded Google Talk iframe. Whatever, no big deal. Except now they were automatically passing through the domain the code was called from (in a Chrome extension, chrome-extension://_chromeextensionidhere_) and appending "/_ah/channel/xpc_blank". Fine, whatever. I don’t understand the changes, and I don’t really care to. The problem, I discovered, is that the new code rejected anything that wasn’t on the http or https protocol. Which these weren’t.

OK, fair enough. I downloaded the javascript file that’s responsible for making the channels ([http://talkgadget.google.com/talkgadget/channel.js](http://talkgadget.google.com/talkgadget/channel.js)) and substituted in my local channel.js file for the http://_yourappid_.appspot.com/_ah/channel/jsapi file in the script tag. Then, in my local file, I added chrome-extension to the test for http and https, so extensions were listed as ok. Loaded it up, and… it failed. A dynamically generated file that Google hosts itself tested again. Darn.

And then I had an idea. What if, instead of trying to make the tests allow the link, I tried to make the link pass the test? It was worth a shot. So I changed the /_ah/channel/xpc_blank to be http://_yourappid_.appspot.com/_ah/channel/xpc_blank, and fired it up. A little ferreting around (had to find the code that was extracting the current domain, match it for the chrome-extension protocol, and tell it to _not_ append the domain and path if the protocol was chrome-extension. Otherwise, it was giving me "chrome-extension://_extensionidhere_/http://_yourappid_.appspot.com/_ah/channel/xpc_blank", which is not _quite_ what I wanted) and lo and behold, the extension worked again.

I fired off an email to [Moishe Lettvin](http://www.google.com/profiles/moishel), the developer who had been working with the testers on the API, letting him know about the bug. He acknowledged it existed, but claimed he didn’t know how to fix it off-hand. I explained what I had done, and he acknowledged that was the correct fix. He has (by now, I presume) applied the fix, and it will be rolling out with the next GTalk frontend rollout. Unfortunately, that could be weeks or months away. So I’m keeping my hacked together file, and am going to end up pushing it out for android2cloud. And I’m going to let you do the same.

Using it is simple:

1. Grab yourself the [channel.js](http://code.google.com/p/android2cloud-beta/source/browse/channel.js?repo=chrome) file I’ve modified.
2. Put it in the folder of your Chrome extension.
3. Open the channel.js file, and modify line 2: `var myHost = "http://connegt.appspot.com";` needs to become `var myHost = "http://yourappid.appspot.com";`.
4. Build a webpage that is Channel-enabled, as usual. Your chrome extensions are just HTML pages, so you shouldn’t have to modify anything at all.
5. Change "http://_yourappid_.appspot.com/_ah/channel/jsapi" to "/channel.js" anywhere it appears in your code (though you should only have it in there once…)
6. Enjoy!

It’s really that simple to have your browser updated in realtime. I don’t think you have any excuse left for polling.
