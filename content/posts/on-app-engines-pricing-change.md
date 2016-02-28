+++
title = "On App Engine’s Pricing Change"
url = "/posts/on-app-engines-pricing-change"
date = "2011-09-03T04:55:00Z"
+++

By now, most of you running [App Engine](http://appengine.google.com "Google App Engine") applications have received the dreaded email: App Engine is leaving beta. Normally, that’d be a great thing. But as they announced at I/O, that means the pricing structure is changing, because now they need to actually pay for their operation; in other words, they can’t keep operating at a loss. So the pricing structure was simplified a bit, and prices were hiked.

For [2cloud](http://www.2cloudproject.com), this is _terrible_ news. We were having trouble operating under the old pricing structure; making ends meet under the new pricing structure is going to be difficult. Our [new quota system](http://blog.android2cloud.org/2011/08/about-quota.html "About the Quota on the 2cloud Blog") is hopefully going to help make it happen. We’ll see.

I’m a little disappointed with the change; not because Google’s charging us more, not because we have even more pressure on us to get our app to pay for itself; those I understand. It is not Google’s job to pay for my app, and it is not Google’s fault that I haven’t been able to come up with a monetisation plan. Google is not a charity, they are a company. The fact that they’ve given us this long to figure it out is a _gift_ and a _blessing_, not a license to demand more time from them. My disappointment, instead, is rooted in the “one pricing scheme to rule them all” approach. I understand its goals—make the pricing scheme more predictable and less confusing—but I don’t think it fits well. Our app spent most of its free CPU quota on creating [channels](http://code.google.com/appengine/docs/python/channels/ "Channel API"); now that Channels are split out from the CPU in terms of the quota, we’ll have a bunch of unused CPU and pay even more for Channels than we already would have. I would’ve liked to see a bit more flexibility in the pricing scheme than is currently offered.

In the end, though, App Engine is still fantastic. And even as we look at whether another hosting provider would provide a better experience for our users, I feel nothing but fondness and loyalty to App Engine. If we do end up developing another set of server software for [AWS](http://aws.amazon.com "Amazon Web Services") or a similar service, I’d like to keep our App Engine code running in parallel. It still remains the best service to quickly and easily start a project on.
