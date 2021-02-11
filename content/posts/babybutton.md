+++
summary = "A writeup on a project I actually completed. How to build a button that will send messages when pushed."
url = "/posts/babybutton"
title = "Building a Baby Button"
date = 2021-01-17T12:09:45-08:00
has_tweet = false
draft = false

[img]
file = "babybutton.jpg"
+++

I've been [struggling to finish a side project for a
while](/posts/scared-shipless), but I've finally _actually finished something_,
so I thought I'd write it up.

Ethan and I are [in the process](https://adoption.carvers.co/progress/1/) of
[adopting a baby](/posts/family), and we're at the point in the process where
we can get a phone call basically at any time saying our baby is being born and
we need to travel to some hospital anywhere in the United States to pick them
up. Like, _right now_.

This is stressful, and one of the things that was stressing me out was telling
everyone what was going on in that moment. We needed to tell my boss I was not
going to be in work, we needed to tell our friends that were going to be taking
care of our house and dog that we were leaving, and we needed to tell our
families that things were in motion and we'd be in touch soon. That's a lot of
texting and calling when you're trying to arrange travel and lodgings and get
out the door.

Fortunately, computers.

We decided we wanted a button we could slam that would just... tell everyone
_for_ us. No texting, no calling, just smacking a button in the garage as we
got in the car. This seemed doable! A button that, when pushed, calls a
program, which contacts any of the very-usable APIs for communicating with our
loved ones, and sends a message on our behalf. This seemed like a thing I could
do in, like, a night.

For once, my instincts about how long a project would take to build were
_mostly_ right. Getting programmatic access to all these communication methods
took a little longer, just because we're not administrators for all the
communication methods we use, and so couldn't grant ourselves API access. Which
meant waiting for and convincing other people to give us access.

We used [a random USB button we found on
Amazon](https://smile.amazon.com/gp/product/B0814C1Q43/) to be the push button.
It doesn't have mounting hardware, so we just screwed right through the plastic
to affix it to our garage wall. YOLO.

We used [a Raspberry Pi 4 Model
B](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/) with [a PoE
hat](https://www.raspberrypi.org/products/poe-hat/) to plug the button into and
run the program. Probably overkill, but whatever. When we bought our house, the
first thing we did upon getting inside was pay people to run CAT-6 ethernet all
over it for us, and fortunately had thought to have them put an ethernet port
in the garage. Right where we wanted the button, coincidentally! The PoE hat
meant we could just plug the Raspberry Pi into the ethernet port and didn't
need to worry about power at all. It is not, strictly speaking, necessary. But
I like the one cable setup. Putting the Raspberry Pi in a [SecurePi
case](https://chicagodist.com/products/securepi-case) let us protect it and
mount it securely on the wall next to the button.

Then I [wrote some software](https://github.com/carvers/babybutton). It's just
a Go binary that, when called, calls the Slack, Discord, Twilio, and Matrix
APIs to send the messages you specified. I used
[HCL](https://github.com/hashicorp/hcl) for the configuration file to specify
the messages you want sent, and I stored the credentials for all these services
in a [Vault](https://vaultproject.io) cluster we already had running on our
home network.

The last bit to do was wire the program up to run when the button is pushed.
[inputexec](https://github.com/rbarrois/inputexec) is a neat little utility for
that, though it hasn't been updated in a while. It lets you listen for keypress
events from a specific input device, then execute a program when they happen.
Exactly what I wanted! I configured the button (it has a hardware pin-based
configuration inside) to send F12 when it's pushed, and set up inputexec to run
my Go binary when F12 is pushed. The code for inputexec is a little out of
date, so to get it working with the Python version that ships with Raspberry Pi
OS I had to modify it a little bit, but it was only two lines and didn't derail
me too much.

Put it all together, and it's working exactly how we want. Now we know we're
not going to need to be typing on our phones while running around the house and
packing things up, frantically searching our brains for who we need to contact
and what we need to tell them. We can just smack a button and go.
