+++
date = "2012-04-28"
summary = "“Eating your own dog food” is the phrase used to describe interacting with your product the way customers do. It’s considered good practice, to the point of being common sense. It can be taken too far."
title = "Nobody Can Live on Dog Food"
url = "/posts/dogfood"
[quote]
attr = "Joel Spolsky"
text = "“I suggested that everybody build at least one serious site using CityDesk to smoke out more bugs. That’s what is meant by eating your own dog food.”"
+++

I’ve always intuitively agreed with the practice of eating your own dog food. 
It’s hard to argue with “if I don’t use it, why should my customers?”

At [Iron.io](http://www.iron.io), my main responsibility is the [Dev Center](http://dev.iron.io). 
I do a lot of work around trying to make developing on Iron’s products 
easier and more pleasant.

It stands to reason, then, that I spend a lot of time building things using 
Iron’s products. I spend a lot of time writing examples, building client 
libraries, and interacting with our APIs in essentially the same way we expect 
our customers to.

As part of my ongoing work with [2cloud](http://www.2cloud.org) (yes, it is 
ongoing, just seriously slowed, thanks to my responsibilities at Iron), I’ve 
been working on a [Go](http://www.golang.org) wrapper for [Stripe](http://www.stripe.com). 
As I grew frustrated with something I was working on today, I took a break to 
hack on the Stripe library for a little while. And as I was writing unit tests, 
I realised what would really help me was a dump of every conceivable permutation 
of their response objects. And as I sat there, thinking about how hard it would 
be to convince the Stripe engineers to put in the hours to develop this, it 
struck me: I’m an engineer at a company with an API. We don’t have this.

Why don’t we have this?

So I’m going to work on this. I’m going to work on this great resource for 
testing, but not because I spent the last four months so deeply immersed in our 
products that I saw the need. I’m going to work on it because I took a break from 
our products and found the need elsewhere, then applied it to Iron.

Eating your own dog food is great, and it’s definitely something you should do, 
but it runs the risk of being myopic and constraining. Sometimes you need to 
use other people’s products, get exposed to differing viewpoints, and approach 
things from a new perspective before you can achieve the cognitive dissonance 
necessary for learning.
