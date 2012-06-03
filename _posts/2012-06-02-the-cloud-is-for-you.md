---
title: The Cloud Is For You
layout: post
categories:
  - posts
quote:
  text: "&quot;The unit of thinking around here is a terabyte.&quot;"
  attr: Wayne Rosing, Google
summary: "Cloud computing is not the same as Platform-as-a-Service."
---

**Disclaimer**: I work for a [cloud computing company](http://www.iron.io), 
so I'm obviously a bit biased in favour of the cloud. That said, my views, 
as always, are my own, and are not indicative or reflective of Iron.io's.

I don't normally do this, but [a post](http://justcramer.com/2012/06/02/the-cloud-is-not-for-you/) 
just hit Hacker News based on one of the most frustrating misconceptions 
people have about the cloud, and I feel compelled to point it out.

The cloud is *not* a specific platform-as-a-service. It is not App Engine, 
it is not Heroku, it is not EC2. Using those platforms does not mean you 
are using the cloud, and not using those platforms does not mean you are 
*not* using the cloud. Those are platforms that are built with cloud 
computing in mind. They are *not* cloud computing itself.

The cloud is *a way of thinking*. It is a development paradigm, an 
infrastructure decision, an architectual choice. It means thinking of a 
server as the smallest piece of architecture, instead of a process. It 
means making discreet, modular services that are hardware-agnostic. It 
means an easy deploy strategy, so the easy scaling inherent in modular, 
discreet system can be fully taken advantage of.

It means that a server failing has the same severity as a bug. The response 
is simple: isolate the server so it is no longer handling traffic, replace 
the server, then diagnose how it failed.

This may seem like common sense and just good practice to you. It does to 
me, too, and that's why I love the cloud. But this wasn't always the case. 
If my history is correct (I believe it is), the movement started at Google 
as "cluster computing" when they needed a way to make cheap hardware capable 
of storing *the entire internet*. Problems stopped being interesting unless 
several servers were involved.

I don't know about you, but I remember when I started web development, I 
considered myself lucky to have a single server. I was a young high school 
student, with no credit card. My parents were wary of the internet, and not 
very helpful when it came to turning my money into internet purchases. I 
remember taking a yearly trip to the local shopping mall, buying a prepaid 
debit card, and purchasing a year lease on the cheapest shared host I could 
find.

This may sound absurd, but I can think of several companies off the top of 
my head that run server architectures similar to this. Not a shared host, 
maybe not even just one server, but the database, the cache, and the 
application are all on one machine.

Sentry certainly had a problem, but it wasn't with the cloud. Actually, the 
cloud saved Sentry. Sentry's problem was with *Heroku*. Heroku wasn't the 
right PaaS for Sentry, or Sentry wasn't built to take advantage of Heroku's 
strengths. Heroku is great, and I'm sure Sentry is quality software, but that 
doesn't necessarily mean they're a match.

The fact that Mr. Cramer is touting how easy it is to stand up servers and 
the fact that it took him three days to switch from someone else's hardware 
to his own, with little-to-no architecture shift, makes it sound like the 
cloud is most certainly for him.

And Dave, if you're still looking for a solution to those background workers, 
shoot me an email: paddy@iron.io. I'd be more than happy to help you get 
started on [IronWorker](http://iron.io/products/worker), and I'm fairly 
confident it can restore your faith in the cloud.
