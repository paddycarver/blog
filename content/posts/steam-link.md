+++
summary = "How I set up a Steam Link on a Raspberry Pi."
url = "/posts/steam-link"
title = "Using Steam Link on a Raspberry Pi"
date = 2020-05-23T05:54:04-07:00
has_tweet = false
draft = true

[quote]
attr = "Person who said it"
text = "“Thing they said.”"

[img]
attr = "Person who took the picture"
file = "file in static/img/posts to use as the picture"
link = "link to the picture if required by rightsholder"
title = "title of picture"
+++

After years of tweaking, I've got a setup for playing video games in my living
room, from my couch, that I'm pretty happy with. So I wanted to write it down,
as notes for when I inevitably need to set it up again, and in case someone has
the same goals I do.

## Goals

I have some pretty basic goals for playing games. I'm not competitive about it,
my husband and I just like to play RPGs and narrative-driven games, and
occasionally I'll pick up a strategy game or visual novel game. We're not big
on online multiplayer, and try to avoid it. I already have a job, I don't need
an(other) unpaid one. And online games always end up being a job in at least
one of two ways: they're either filled with people who sink way more time into
the game than you do, wrecking the challenge curve for you, or they're games
you need to coordinate with friends to play together. Syncing schedules is
work. I'm not about that life.

I'm also, put mildly, uncultured swine, and don't appreciate the finer things
in life. By which I mean, I'm pretty tolerant of lower framerates, loss of
audio quality, and loss of video quality. To an extent. I'm not immune to it,
but from what I gather, I'm less sensitive to it than [some of my
friends](https://dstaley.com).

Also, hardware lock-in annoys me. We love our games for their stories, and
sometimes you want to revisit a story. We were big PlayStation gamers for a
while, and then the PS3 dropped support for PS2 games, and then the PS4 came
out without support for PS3 games. So for a hot minute, we had three
generations of PlayStations sitting in our entertainment center. That's silly.
And yes, we could and did get the remastered versions of games, but that's not
a full solution for two reasons: first, we want to buy a game once, not every
hardware cycle. Our game library should grow over time, not get reset every
time a new hardware cycle spins up. Second, not every game got a remaster.
Dragon Age: Origins, Dragon Age II, and the Mass Effect trilogy are still not
available on PS4. We love those games, we want to revisit them, but it's silly
that they need what is essentially a dedicated console to be played.

Finally, gaming is a social experience for me. I don't want to go sit in a
room, by myself, and play a game. I know it sounds silly, but I've been living
with my husband for 7 years now, and I... still like him? I still want to hang
out and spend time with him? Some of the earliest moments of our relationship
were me watching him play Skyrim and making fun of how bad he is at it. (Ethan
is comically bad at video games, it's very charming.) We like hanging out in
the same room, even if we're doing our own thing. He'll browse social media on
his phone while I play a game; when we find the rare couch co-op game we can
play together, we'll play together. So I want to play from my couch, on my TV,
with the speakers and the Hue lights and my husband sitting next to me; I don't
want to be sitting in a computer chair at a desk.

So obviously, we picked up PC gaming. Our game collection now is only additive,
and we can bring it forward as our hardware improves. We can find most games on
PC. We can even find some DRM-free. I don't worry too much about the details or
optimize anything, because I don't care to fiddle with it. I just buy whatever
hardware [Dylan](https://dstaley.com) tells me to, and don't overclock
anything, and that approach seems to be working fine for me. My general rule of
thumb is I buy from [GOG](https://gog.com) when possible, because it's
DRM-free; [Steam](https://steampowered.com) when something's not available on
GOG, because it has the largest selection and best integration with Steam Link,
and [Epic](https://epicgames.com/store) or [Origin](https://origin.com) when
I... well, when the game isn't available anywhere else.

To get that couch experience we wanted, we use [Steam
Link](https://store.steampowered.com/steamlink/about/), which lets you play
your games on your PC, but displays them on a different device. It's pretty
neat, and it also means that our games are now no longer limited to a single
room; we can have a setup in a few rooms, and play on whichever makes sense.
For example, our living room has one setup, I put another in our rec room, and
I can also stream games to my laptop wherever I am. That flexibility appeals to
me.

## The Hardware

I'm using Raspberry Pi 3s to power the Steam Link. My house has CAT6 cable run
through the walls, so I get a good connection on them. They output to the TVs
via HDMI (through an A/V receiver in the living room). I keep a keyboard and
mouse with them, because despite my best efforts, that still seems to be
required, though I can get away with using them infrequently. I specifically
chose a bluetooth keyboard and mouse that came with a dongle; pairing and
unpairing is annoying, so the dedicated dongle makes life easier, everything
just always connects.

I'm using a Dualshock 4 as my controller. I tried the XBox Wireless Controller
and got weird glitches; phantom or laggy joystick controls, if I remember
right. I also tried the Steam controller, because we picked one up for $5, but
I just can't deal with the touchpad right joystick thing. It's pretty bad, and
playing anything that requires some accuracy with it is basically impossible.
The Dualshock 4, though, works like a charm. The only problem I had was it
would randomly disconnect on me, and I'd have to reconnect the controller. Not
ideal. I have a sneaking suspicion this is because the Raspberry Pi's bluetooth
antenna is underpowered, because a $7 bluetooth dongle fixed it for me. Now it
works like a charm. It lasts for at least several hours of active use; I can't
tell you more about battery life than that, because we always just place it
back on a charging cradle after using it. It hasn't run out of battery on us
yet? One thing that was tricky was figuring out how to turn off the controller
when you're done with the game, because it won't turn off automatically when
you stop streaming Steam. Just hold the PS button for like 10 seconds; it'll
power down, and reconnect automatically when it turns back on.

## The Software

We're using Raspbian Buster on our Pis, with the official Steam Link app. I
disabled bluetooth and wireless, as we're getting bluetooth from the dongle and
wireless isn't necessary when we're using Ethernet (and I don't want it
accidentally getting used).

To get 5.1 surround sound working using HDMI, I had to tweak some configs.
Something something insert notes here on how I did that.

Insert notes on starting Steam Link at launch.

To disable the screen blanking, I installed xscreensaver, then disabled the
screensaver using it. Seems to have worked just fine.

## The Results

We now have a setup that lets us buy games once, and upgrade the hardware
running the games without losing our library in the process. Any games that
don't rely on a server we'll be able to play for the foreseeable future. We
leave the Pis running, and when we switch to their inputs, we see the Steam
Link interface, ready to connect, controllable by the Dualshock 4. If the Pi
isn't on, when it boots up, it'll automatically launch the Steam Link
interface. We can play from our couch, with minimal keyboard/mouse usage
necessary, and maybe 50% of the time not necessary at all. Only general purpose
computers are used for all of this, meaning when I have a bad idea, I can write
software that can run on any machine involved. I can also debug and dig through
any of the machines involved.

## What's Next

The next big upgrade I want for this system is to switch the Pi 3s to Pi 4s.
Better processors, 4GB of RAM, 4K HDR support, and a gigabit connection sounds
nice. And when I do, I want to add a PoE hat to the Pis, so they don't even
need a power cable, they can just draw power from their Ethernet connection.
One less cord is always a win.

I miss my Share button actually recording video. It usually gets mapped to
something else when used for Steam Link, but my graphics card has support for
PS4-like recording and capturing of pictures. I miss using it. So I'd like to
figure out a way to start doing that stuff again. I have some hare-brained
schemes about bluetooth buttons that daemon processes on the Pi listen for so
they can signal server processes on the Windows machine, which will simulate
the keypresses for capturing video or screenshots. But that particular bad idea
will have to wait for another day.
