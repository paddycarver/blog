---
title: Realtime and Go
layout: post
categories:
  - talks
quote:
  text: "&quot;A better C, from the guys that didn&apos;t bring you C++&quot;"
summary: "A talk about using Go for realtime web application development. Created for RealtimeConf Europe, this talk was also given at the University of Buffalo and for the XMPP UK meetup group."
permalink: /talks/goonaboat
---

This is a talk I built for the amazing [RealtimeConf Europe](http://realtimeconf.eu) conference (you can read [my writeup of the event](/posts/realtimeconfeu)), but I practised it on students at the University of Buffalo first. Following RealtimeConf Europe, one of the attendees asked me to give the talk for the [XMPP UK](http://lanyrd.com/2013/xmpp-realtime-uk-meetup/) meetup.

The talk is supposed to be an introduction to Go for people familiar with realtime web programming. The term &quot;realtime&quot; is a bit loaded, so in this context, we&apos;re using it to describe websockets, push notifications, and anything that gets content to users as quickly as possible. Your definition may vary.

The core thesis of this talk is that realtime is, at its core, a concurrency problem. You need to, at the very least, subscribe and unsubscribe listeners, and you need to notify them of events. Two independent tasks, so we&apos;re talking about concurrency. From this premise, it follows that Go&apos;s concurrency primitives and support make [Go](http://golang.org) a great option for making realtime web applications. I went on to give a concrete demonstration, walking through the [source code](https://github.com/paddyforan/goonaboat) for [a demo](http://growup.goonaboat.com) that I had made.

The first iteration of this talk was given to UB students at their ACM meetup. You can view [a video of it](http://youtu.be/wC5W8x1h6mM). The talk was rewritten from scratch following this experience, as I was unsatisfied with it.

The next iteration of this talk was given at RealtimeConf Europe. You can view [a video of it](http://youtu.be/1fWY2BUDYn0). This is, more-or-less, the final version of the talk. The slides are available at [goonaboat.com](http://goonaboat.com).

The final iteration of this talk (a slide was removed) was given for XMPP UK. You can view [a recording of it](http://www.youtube.com/watch?feature=player_detailpage&v=RroA2NzzX64#t=5808s) (my talk starts around the 1 hour, 35 minute mark).
