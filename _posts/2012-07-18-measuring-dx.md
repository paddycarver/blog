---
layout: post
published: false
title: "Measuring DX"
quote:
  text: "&quot;If you don't know what you're testing, all the results in the world will tell you nothing.&quot;"
  attr: "Eric Ries, The Lean Startup"
summary: "Developer Experience is all about working to make your platforms pleasant for developers to build on. But how do you measure your success at making people happy?"
---
[Developer experience](http://www.developerexperience.org) is a pretty new field. There aren't as many people working on it as there should be, and there isn't enough literature about it to learn it by reading. It's still something you need to just figure out as you go.

When I [started](/posts/developer-experience-engineer) as [Iron.io](http://www.iron.io)'s first Developer Experience Engineer in mid-June, I didn't have a whole lot to go on. I talked to some wonderful people in the community and read a lot of great blog posts and [resources](http://developer-support-handbook.org), but at the end of the day I was pretty much just doing my best to learn what worked and what didn't as I went.

There's a problem with that, though: how do you know what's working?

There aren't a lot of resources to measuring developer experience, the way there are for [UX](http://www.measuringux.com). Not a lot of advice, not a lot of tools, not a lot of case studies. I was having a hard time finding out how I could figure out if I was even doing the right things.

So here is what I came up with.

## Google Analytics

[Google Analytics](http://www.google.com/analytics) is your friend... but you need to know how to use it. We use Google Analytics to track our [Dev Center](http://dev.iron.io), so I have insight into how our developers are interacting with our documentation.

### Bounce Rate: Good or Bad?
It's tempting to say that a high [bounce rate](http://support.google.com/googleanalytics/bin/answer.py?hl=en&answer=81986) is a bad thing, but that's misleading. [Some pages](http://dev.iron.io/worker/reference/environment) are meant to give the developer the information they want in the quickest way possible.

So the answer is that pages with a low bounce rate are bad, because developers have to dig for the answer they want, right? Not so fast. [Some pages](http://dev.iron.io) are meant to be landing pages that direct developers to the different content we have available, and [other pages](http://dev.iron.io/worker) are meant to be quick overviews that show off the possibilities of our platform and lead developers to explore the capabilities further. For those pages, a high bounce rate may actually be *bad*, as it may signify that the page is frustrating, boring, or off-putting to developers.

**When considering a page's performance, always consider the page's *purpose*.** Google reportedly used users who returned to the search page after clicking a link to measure poorly performing queries. Sometimes, people using your product means your product failed the first time. You should be finding those failures and fixing them.

### Visitors Flow

Google Analytics has this great view called &quot;Visitors Flow&quot; that breaks down the path users are taking through your website. What makes Visitors Flow so great is that it tells you where you are losing people. It shows you the percentage of people who leave after the page and where the people who stayed went next. For your pages that should lead into other content, this helps you see how many people you're losing and whether the people who are staying are going where you expect. For the pages that should be quick reference, it helps you see where people are going to try to find whatever you're looking for.

**Always have a traffic flow in mind for your pages.** If a page is a reference page, developers should be entering on that page and leaving on it. This means the page is the first step in the visitor flow (the entry page) and has a high bounce rate. For exploratory pages, this means plotting out what you think the developer needs to know and a path that will teach them that information. You can then compare that path against the visitors flow diagram to make sure you're leading your developers through your content effectively.

## Developer Interaction

This section's a bit easier to explain and measure than the Google Analytics section and a bit more concrete. I think, in most situations (in ours at least), every time the developer *has* to talk to someone on the team, that is an area where the developer experience has failed. Whether that's posting a question in the mailing list or forum, engaging support, or asking a question in the public chat (which is where [most of Iron.io's customer interaction happens](http://get.iron.io/chat)), that developer had to stop *actually making things* to figure out how to interact with your product.

On a similar note, nobody reading your documentation may actually be a *good* thing. If they have to stop what they're doing to read your documentation, that's time they could be spending on actually building things.

In a perfect world, your platform would be so easy and intuitive to use, the developers wouldn't have to read documentation or ask questions.

I'm currently working on a way to automatically track how much developers are utilising our public support chat room, and using that to gauge the effectiveness of our developer experience. It won't be perfect, but it can be used as a rough guide.

## Developer Feedback

Developers are people too, which means *they really like to whine*. Odds are, if you give a developer the chance to tell you why you suck worse than IE 6, they will take that opportunity... usually. At Iron.io, our CEO emails users after a week to check in and get their feedback on the platform. The response rate is really high, and some of the biggest gaps and problems in our developer experience have been raised that way.

But there are exceptions. If you have a generally good developer experience with this one massive pain in the butt, you'll be likely to hear about it. If your developer experience is a mess and painful to use, people will more likely just move on with their lives, rather than complain. You have to be salvageable, in the user's eyes, or why bother?

Be honest, who *really* wants to explain to PayPal and Google Checkout all the reasons Stripe is preferred by developers? It's easier to just use Stripe. Even if you could come up with an actionable list, it doesn't feel like PayPal or Google would be nearly responsive enough in implementing those changes, so why bother? As important as asking what's wrong is, listening to the answer *and fixing it* is even more important, or developers will stop answering.

It's also important to remember that this won't actually raise all the problems. Because you'll have developers that never start using your product or who see a dealbreaker and just move on with their lives. Developers are busy people right now. You can't count on them to find all the problems for you. But the developers who are invested in your platform or who are forced to use your platform will likely help you make their lives better.