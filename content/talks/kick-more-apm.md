---
date: '2012-03-23'
quote:
  attr: <a href="https://twitter.com/mattcutts/statuses/172448195723530240" title="Matt Cutts on Twitter">Matt Cutts</a>
  text: "“The ability to write code is pretty much a super power in today''s society.”"
summary: Developers are super heroes. The cloud can help them stop ironing their capes and get back to saving little old ladies from getting robbed. At [Iron.io](http://iron.io), we want to help you do that. A talk I originally gave at [UBHacking](http://www.ubhacking.com).
title: How to Kick More @#% Per Minute Using the Cloud
url: /talks/kick-more-apm
---


I think I had the idea for this talk on accident. I think most my good ideas are 
accidents. And yes, I just implied this talk was a good idea. I stand by that 
implication.

We had just released a new update at [Iron.io](http://www.iron.io), either 
announcing a new partnership or a new product, and I reshared the announcement 
on Google+. I commented that we were kicking more ass per minute every day.

The post, as you can tell by my vague recall, was no more or less important than 
our other announcements. The phrase, though, would stick with me. It became my new 
unit of measurement. As I pondered it some more, I realised that kicking ass was a 
developer's main job: creating something cool, making something faster, more stable, 
more awesome. As a developer, I know that's not what developers spend a lot of their 
time on. Sometimes you wind up provisioning servers or finding ways to make the 
architecture that is elegant in concept work in the decidedly clumsy Real World.

That was the first spark for this talk: the realisation that our purpose, at Iron.io, 
was to help programmers, hackers, and engineers kick more ass per minute by letting 
them focus on kicking ass while we take care of the more mundane parts.

The second spark came while I was sitting at home, watching Iron Man. I kept amusing 
myself by finding correlations between Iron Man and Iron.io, and I realised something: 
a super hero's job is, literally, to kick ass. And most super heroes have an assistant, 
a butler, a computer, or some other type of aid that takes care of the mundane parts of 
their lives (paying taxes, preparing food, repairing capes) so they can focus on 
kicking ass.

That was when I realised that Iron.io wanted to be the Alfred to your Batman.

The final piece of the puzzle fell into place when I realised I needed a demo and 
it needed to be unlike an ordinary presentation. I have a background in theatre and 
performance art, so I have a weakness for interactivity and surprising the audience. 
So I made my slides in [deck.js](http://imakewebthings.github.com/deck.js), hooked 
them up to [App Engine](http://appengine.google.com)'s [Channel API](http://code.google.com/appengine/docs/python/channel), 
and integrated [Twilio](http://www.twilio.com)'s API so messages that were texted 
to me could appear on the slides themselves during the presentation. I could then 
integrate IronWorker and IronMQ to text the audience members back during the 
presentation. When I made the plot diagram for the slides (you know, the one they 
taught you back in middle school: rising action, climax, falling action), I used 
the response texts as the climax. I implemented an artificial delay and 
made it possible to queue up more and more workers to process the queue of messages 
to send, showing the parallel processing capabilities of the platform. In essence, 
the room started with disparate beeps when one worker was running, then erupted into 
an orchestra of cell phones as I queued up more and more workers. I then ran through 
the code that powered the workers, explained the architecture, and issued my call-to-action: 
we've made it easy, so it's time to go forth and kick ass.

The slides are available [here](http://kick-more-apm.appspot.com). They were tested 
in Chrome, but (probably) work in any modern browser. As a side-effect of using the 
Channel API in my presentation, I could control my slides wirelessly from a tablet. 
I'll release that code as an open source repository on Github when I get a moment.
