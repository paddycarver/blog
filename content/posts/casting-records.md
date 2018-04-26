+++
date = "2016-08-29T23:36:50-07:00"
summary = "How to cast your record player to a Chromecast Audio, through PulseAudio. For a bonus challenge, it will involve running PulseAudio headless."
title = "Using Google Cast With Your Record Player"
draft = false
url = "/posts/casting-records"

[img]
  attr = "Erwin Bernal"
  file = "record.jpg"
  link = "https://flic.kr/p/axqxZy"
  title = "Record Player"

[quote]
  text = "“We have a secret project at Third Man where we want to have the first vinyl record played in outer space. We want to launch a balloon that carries a vinyl record player.”"
  attr = "Jack White"
+++

I dunno how you ended up at this place. Maybe you hate yourself a little. Maybe, like me, you have a loved one who, for some reason, enjoys records even though you have subscriptions to a music streaming service that _has all these songs already_. Maybe, like me, you’re a little annoyed that what could be a general-purpose solution for making all the speakers in your house talk to each other is arbitrarily limited to only a handful of apps that have bothered implementing its specific protocol. (I can’t cast YouTube Music to my speakers? You’re joking, right?)

Whatever sins led you to this place in your life, here you are: trying to make something that communicates through analog wires talk to your Chromecast Audios. (Or your Chromecasts, I suppose, but for me it was the Audios.)

Well, friend, fortunately for you, I already went through the pain of figuring this out, and have some pointers. It involves PulseAudio. Abandon all hope, ye who enter here. Here there be dragons.

## What You’ll Need

You’re gonna need a Linux box. It needs a microphone input. You’ll also want speakers for it, for testing. You can find them for like $15 [on Amazon](http://smile.amazon.com/dp/B00GHY5F3K). A Raspberry Pi could work, if you get a USB adapter to give it a mic input. I haven’t tried it yet, it may be underpowered and your performance could suffer. No idea, really. Someone not-me try it and [tell me about it](https://twitter.com/paddycarver).

You’re going to need a record player, or whatever it is you want to send music from. Important thing is that it needs to be able to plug into that mic input on your Linux box. For me, this involved an RCA-to-3.55mm adapter. It cost like $5.

You’re going to need at least one Chromecast. Or, hypothetically, any DLNA-capable device, though I haven’t tried that yet.

You’re going to need a whole lot of patience, a chunk of time on your hands, and a thorough knowledge of curse words. We’re dealing with PulseAudio, after all.

## The Plan

OK, so here’s what we’re going to do. We’re going to feed the output of that record player (or whatever you’re using, this could be your phone or your TV or whatever silly thing you want to use) into the mic input for your Linux box. That moves the sound into Linux land, where we can (in theory) do stuff with it.

Once we have the sound in Linux land, we’re going to route it through PulseAudio, where we can (in theory) make it available to other programs and control where it goes.

We’re going to set up [pulseaudio-dlna](https://github.com/masmu/pulseaudio-dlna), which will helpfully add all the Chromecasts and DLNA devices on your network as PulseAudio sinks. A sink is PulseAudio’s fancy way of saying "the place where you want to send the noise", because "output" was too hard, I guess.

To bring it all together, we’re going to use `pacat` to direct the music from the record player (or whatever) to the Chromecast (or DLNA device) you want it to play from.

## Step 1: Making the Music Digital

OK, the first thing we’re doing is making the music digital. Start by plugging stuff in. You’re on your own for this, as it’s mostly a matter of figuring out what adapters you need to turn one plug into another plug. Google is your friend.

Once you can plug your record player into your Linux box, life gets interesting. You need to get that sound into PulseAudio. Your mic input should be setup as a source (PulseAudio’s fancy word for "input") already. If it’s not, Google away. Mine was, I’m of no use to you. Your speakers should be setup as a sink. Again, mine were automatically detected. If yours aren’t, I can’t help you. Google that.

To get things rolling, you need PulseAudio to be running if it isn’t already. If, like me, you’re doing this headless (through SSH or a terminal, not through a GUI) it probably isn’t running yet. `ps -aux | grep pulse` should give you an idea if it is or not. If it isn’t running, `pulseaudio -D` will start it up in the background.

Now you’re going to want to try playing your record player through the computer speakers, before we introduce the Chromecast to the mix. That way, we at least know your PulseAudio setup is working.

You’re gonna need the name PulseAudio is using for your mic input and your speakers.

`pacmd list-sinks` will give you a helpful, if very verbose, list of places you can send your audio. `name:` is the part we’re interested in. Figure out which one is your speakers. As a protip, the `device.string` part has some helpful information, sometimes. `pacmd list-sinks | grep -e device.string -e 'name:'` is the command I ran, which helpfully showed the name (the part I need) and the device string for each of my sinks. Once you have the name, strip off the `<` at the beginning and `>` at the end.

`pacmd list-sources` is the yin to `list-sinks`’ yang. It’s going to tell you all the places you can get your audio from. Same drill, find the mic input in that list.

Finally, moment of truth: let’s bring it all together. Here’s the command:

```
PULSE_SOURCE={YOUR MIC INPUT NAME} pacat -r --latency-msec=1 | PULSE_SINK={YOUR SPEAKERS NAME} pacat -p --latency-msec=1
```

That `PULSE_SOURCE` environment variable tells `pacat -r` which source to read from, and echos the audio to stdout. We then pipe that over to `pacat -p`, which uses `PULSE_SINK` to know which sink to send the audio from stdin to.

You should hear music playing from the speakers right now. If you don’t, you got the `PULSE_SINK` or `PULSE_SOURCE` wrong. Try again. Do not proceed until you hear music, we’re about to make our lives more complicated, and knowing you have this part down pat will protect your sanity.

## Step 2: pulseaudio-dlna

Now that you’ve got the music playing through your speakers, take a moment to rejoice. That was the easy part.

Next we need to tackle talking to DLNA/Chromecast devices using PulseAudio. Fortunately, we have [`pulseaudio-dlna`](https://github.com/masmu/pulseaudio-dlna) for that. As long as it’s running, all the DLNA/Chromecast devices it can find will be added as PulseAudio sinks. Go ahead and download and install it.

Now let’s run that: `pulseaudio-dlna --debug`. If you’re using a GUI, you may see a lot of text scroll by real fast that ends with something like this:

```
08-29 16:57:09 pulseaudio_dlna.discover                       DEBUG    Binding socket to "" ...
08-29 16:57:10 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Kitchen (Chromecast)".
08-29 16:57:10 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Desk (Chromecast)".
08-29 16:57:10 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Great Room (Chromecast)".
08-29 16:57:11 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Upstairs (Chromecast)".
08-29 16:57:12 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Nexus Player (Chromecast)".
08-29 16:57:12 pulseaudio_dlna.discover                       DEBUG    SSDPDiscover.search() quit
```

If that’s the case, go straight to step 3, you lucky jerk.

The rest of us, running headless, are more likely to see something that looks like this:

```
08-29 16:59:52 pulseaudio_dlna.discover                       DEBUG    Binding socket to "" ...
Failure: Module initialization failed
08-29 16:59:52 pulseaudio_dlna.pulseaudio                     CRITICAL PulseAudio seems not to be running or PulseAudio dbus module could not be loaded. The application cannot work properly!
```

If you see that, lucky you! You get to try to run PulseAudio headless.

We know that PulseAudio is running, so that means the PulseAudio dbus module could not be loaded. Let’s dig into that a bit. Run `pulseaudio -k` to kill your PulseAudio daemon, and let’s run it again, in the foreground, with some debug information: `pulseaudio -vvvvv`

Odds are, if you look closely enough, you’re gonna see some output like this:

```
W: [pulseaudio] server-lookup.c: Unable to contact D-Bus: org.freedesktop.DBus.Error.NotSupported: Unable to autolaunch a dbus-daemon without a $DISPLAY for X11
W: [pulseaudio] main.c: Unable to contact D-Bus: org.freedesktop.DBus.Error.NotSupported: Unable to autolaunch a dbus-daemon without a $DISPLAY for X11
```

That’s the root of our problem here. We don’t have X11 running, so we can’t launch a dbus session for PulseAudio. Because we don’t have dbus running, `pulseaudio-dlna` can’t talk to PulseAudio, so it can’t add sinks.

One way to resolve this is to try to use the system PulseAudio session. This is officially discouraged, because it has security implications and [other caveats](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/WhatIsWrongWithSystemWide/). But this is a thing on embedded setups, I guess? So if you’re doing an embedded setup, maybe that’s something to investigate.

Our other option is to start the dbus session ourselves. This sounds hard, but it’s the easiest path forward I’ve found. Let’s do it.

Go ahead and run `dbus-run-session pulseaudio -vvvvv`. You should now, if you look hard enough, see something like this:

```
D: [pulseaudio] main.c: Got org.PulseAudio1!
D: [pulseaudio] main.c: Got org.pulseaudio.Server!
I: [pulseaudio] main.c: Daemon startup complete.
```

If you did, you’re in business. PulseAudio successfully found dbus and everything is right in the world.

Here’s the new problem: that `dbus-run-session` command kills the dbus session after the command following it (`pulseaudio -vvvvv` in our case) terminates. So running `dbus-run-session pulseaudio -D` is going to return right away. And we also need to run `pulseaudio-dlna` in that dbus session.

Fortunately, the fix is pretty easy. Write a small script containing the following:

```sh
#!/bin/bash

pulseaudio -k
pulseaudio -D
pulseaudio-dlna --debug
```

Name it `dlnapa.sh` and make it executable. Then run `dbus-run-session ./dlnapa.sh`. Now PulseAudio will start _and_ `pulseaudio-dlna` will start within the same dbus session.

If you look closely enough at the output, you should see something like this:

```
08-29 16:57:09 pulseaudio_dlna.discover                       DEBUG    Binding socket to "" ...
08-29 16:57:10 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Kitchen (Chromecast)".
08-29 16:57:10 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Desk (Chromecast)".
08-29 16:57:10 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Great Room (Chromecast)".
08-29 16:57:11 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Upstairs (Chromecast)".
08-29 16:57:12 pulseaudio_dlna.pulseaudio                     INFO     Added the device "Nexus Player (Chromecast)".
08-29 16:57:12 pulseaudio_dlna.discover                       DEBUG    SSDPDiscover.search() quit
```

Hooray! It finally works!

## Step 3: Bringing It All Together

OK, we finally have the record player feeding into PulseAudio, and we have our Chromecasts and DLNA devices as sinks for PulseAudio. The last step of this is to feed the record player source into the Chromecast sink we want to use. We’re going to use that same command from the very beginning for this (making sure to leave the `dbus-run-session ./dlnapa.sh` running!):

```
PULSE_SOURCE={YOUR MIC INPUT NAME} pacat -r --latency-msec=1 | PULSE_SINK={YOUR CHROMECAST NAME} pacat -p --latency-msec=1
```

The Chromecast name is much easier to find: `pacmd list-sinks | grep "chromecast"`.

If all went well, you should hear sound from your speakers! There will almost certainly be some delay. But, for me at least, it’s a small price to pay.

Keep in mind, the music only places as long as _both_ the `dbus-run-session ./dlnapa.sh` command _and_ the `pacat` command are running. Kill either one, and the music will cut off.

Also, sometimes the music gets garbled weirdly. I haven’t quite figured out why this is yet. The easiest solution I’ve come up with is killing and immediately restarting the `pacat` command. A few seconds later, the music will cut out for a split second, then come back in sounding just fine.

## Further Work

So that’s where I am right now, and I’m pretty happy with it. The next thing I’m going to try to figure out is getting a dbus session running whenever I SSH in, so I don’t need the `dlnapa.sh` script. If I can get that working, and get PulseAudio starting when I SSH in, and the `pulseaudio-dlna` server running when I SSH in, then I just need to SSH in and run the `pacat` command. And eventually, I’d like to get a better interface on that, so Ethan can use it when I’m not around, without learning what SSH is and how to operate a command line.
