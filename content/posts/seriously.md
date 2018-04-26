+++
date = "2012-10-23"
summary = "I am a kid just out of college, with no sense of professionalism, and no formal education in my line of work. And yet, you people seem to have an absurd fascination with taking me seriously."
title = "How Do You People Take Me Seriously?"
url = "/posts/seriously"

[quote]
attr = "Bo Burnham, Art is Dead"
text = "I must be psychotic, I must be demented, to think that I’m worthy of all this attention."
+++

To date, I have “published” precisely two pieces of software. The first was [2cloud](http://www.secondbit.org/2cloud), a hack I wrote in my spare time to learn how to write Android apps. It was subsequently [covered by Lifehacker](http://lifehacker.com/#!5604248/android2cloud-opens-urls-from-your-phone-in-chrome), exploded into an open source project far beyond my ability to control, and eventually went on to earn a rating of 8/10 from Wired.

The second was [just published this weekend](http://secondbit.org/blog/introducing-pastry/). It’s a distributed hash table written in Go.

I was nervous before releasing this particular piece of software. It’s more sophisticated and complex than anything I’ve released in the past. Also, my testing of it was “light”, at best. I fired up a few Nodes on my laptop, had them send messages at a set interval, and watched what happened to make sure things made sense within the context of the algorithm. I was about 70% sure the software implemented the algorithm correctly and wouldn’t make mistakes when routing the messages. I posted about it on the Go mailing list and, almost as an afterthought, linked to the blog post on Hacker News.

So imagine my surprise when I saw this:

![We’re number one! We’re number one!](/img/pastry-hacker-news.png)

It wasn’t long before the blog started seeing traffic from all over the world. Watching the pins drop on [Gauges](http://get.gaug.es) was a nice way to spend my ungodly-hours-of-the-morning on Saturday (I ended up sitting up all night, watching people react to the post, answering questions, and generally attempting to pretend I could manage the situation. Also, I was waiting for someone to call me out on writing shitty software and daring to release it).

{{< bigimage src="/img/pastry-gauges.png" title="AirTraffic Live makes me feel like a Bond villain" >}}

When all was said and done, the post had been read by over 10,000 people. Every time I remember that, I feel like Mark Zuckerberg in *The Social Network*. “Thousand. The site got ten thousand hits.”

{{< bigimage src="/img/pastry-cloudflare.png" title="Also, CloudFlare apparently saved us a gigabyte in bandwidth. For a text post." >}}

I’m seeing a pattern here. Every time I do *anything* online, it seems to be a big fucking deal, for reasons I cannot begin to fathom. My friends have started to notice, too. It has become expected that when I do something, the internet will at least take a passing notice.

And that’s something that worries me. Lightning struck twice, but will it keep striking? Does the internet pay attention to the things I do because I do good work, or because I get lucky? I am inclined to believe the latter; I know too many engineers who are better at what I do than I am who get less attention than I do. Which is only a little awkward.

I have no idea why you people take me seriously. I was terrified that someone would call me out for writing shitty software, and instead the worst I got was a billion people complaining that I could have bent over backwards to make a message queue work instead of writing my own software. Which is annoying as all hell, believe me, but it’s hardly on par with being told you suck at what you do and getting laughed at for daring to release something that you found challenging to write. Not a lot of work, but intellectually challenging. To this day, I’m still not confident enough to say I’m an expert on Pastry, the algorithm I implemented. Nobody seems to care.

So please, if you see me on Twitter (where you will be enjoying a stream of my childish, banal, and vulgar tweets... typically about unicorns or Call Me Maybe), please take a moment to explain to me how you can possibly take me seriously. Because it baffles me that you apparently do. And whenever anyone asks how I managed to gain such a reputation, I’m just going to have to stick with my default answer:

![I am Mr. Sex. Also, Moriarty is my spirit animal.](/img/mrsex.gif)
