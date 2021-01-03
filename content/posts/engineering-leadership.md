+++
summary = "To mark becoming the Engineer Lead for the Terraform Plugin SDK, some thoughts on what engineering leadership means to me."
url = "/posts/engineering-leadership"
title = "Engineering Leadership"
date = 2020-08-14T09:43:01-07:00
has_tweet = false
draft = false
+++

In the Fall of 2019, I was working on the [Google Cloud Platform provider for
Terraform](https://registry.terraform.io/providers/hashicorp/google) and was
asked to be the Engineering Lead for HashiCorp for the project. I agreed, but
wanted to know what that meant, and nobody had a really good answer for me.
Everyone agreed it largely looked like continuing to do the job I was already
doing, perhaps with some institutional authority behind my actions, and that
the boundaries of that authority are something that the Engineering Manager,
Product Manager, and Engineering Lead should negotiate amongst themselves.

I ran with that and figured some things out, and six months later left the team
to work on the [Terraform Plugin
SDK](https://github.com/hashicorp/terraform-plugin-sdk) instead, leaving my
Engineering Lead role behind. Now that I've been asked to be the Engineering
Lead for the SDK team, I want to take the opportunity to talk about a couple of
the things the role means to me. It's not an exhaustive or universal list, but
it's a couple of things that feel right to me.

## Making Good Technical Decisions

I think the first priority of an Engineering Lead is to make sure their team is
making good technical decisions. Right? The "Lead" suggests guidance and
direction, and the "Engineering" suggests limiting that to technical scopes.
But thinking through this ends in priorities people tend not to expect.

It's easy to think that means the Engineering Lead should be making every
decision or have veto power over every decision, but I think that's putting too
much responsibility on a fallible human. Not all my ideas are good ideas, not
all my decisions are right, and I don't want the pressure of the system relying
on me to be right. That's not sustainable, safe, or kind to me.

So if I'm not making the decisions myself, and don't even have veto power over
them, how am I supposed to make sure the team is making good technical
decisions? Well, let's look at how good technical decisions get made.

Good technical decisions are made by people who are well-rested. So it's my job
to make sure we have a strong team culture of self-care and work/life balance.

Good technical decisions are made by people who trust each other. So it's my
job to cultivate a high-trust environment on our team.

Good technical decisions are made by people who feel safe. So it's my job to
cultivate an environment where people can feel safe, and can safely be
fearless. An environment where it's hard to break things on accident. An
environment where, when something inevitably does break, it's not _someone's_
fault, it's the _team's_ fault. This means encouraging team ownership of the
systems that keep us safe, so the root cause of any incident isn't "someone did
something wrong", it's "we failed to make the system robust against someone
doing this thing".

Good technical decisions are made by people who feel empowered to bring their
insights, ideas, and experiences to the table, and who feel secure that their
contributions will be respected, valued, and recognised. So it's my job to make
sure everyone has an opportunity to contribute, and every contribution is
valued, and that people get credit and recognition for their contributions.

Good technical decisions are made by people who can bring their whole selves to
work, people who don't need to spend time and bandwidth gauging what's safe to
share. So it's my job to ensure a culture of respect, inclusivity, and kindness
on the team.

Good technical decisions are made by people when they're given time and space
for consideration and processing. So it's my job to work with the Engineering
Manager and the Product Manager to make sure that the workload we're doing is
scoped appropriately for the time we have to do it in, and that people feel
comfortable standing up and walking away from the computer to go think for a
bit.

Good technical decisions are made by people who are aware of the context and
history of the problem they're working on. So it's my job to surface details,
and build a culture of asking _why_ things are the way they are, encouraging
and giving space for gathering the context necessary to make an informed
decision. It's my job to build a culture of writing our ideas and reasoning
down in discoverable places, so that future-us or those that follow us will be
able to understand our context.

Good technical decisions are made. A decision, therefore, is better than no
decision. So it's my job to understand when we're getting lost in the weeds, or
bikeshedding, and force a decision in a timely manner.

Whenever I think about culture, I think about the phrase "that's not what we do
here", usually deployed when a cultural norm is violated. It's not a value
judgment on what was done, it's a simple assertion about the identity and
culture of the team and how that manifests. As an Engineering Lead, my job is
to ensure that what we do here and what we don't do here are going to lead to
good technical decisions.

I am not the only person on the team with these responsibilities, but they are
my responsibilities, too.

## Making It Not Depend

An answer we like to give at HashiCorp is "it depends". And that's true! It
often does. Things are different for an enterprise and a startup, for a bank
and for a blog. And recognising that complexity and spectrum is something that
I think HashiCorp does really well at. And that applies internally, too; there
are differences between managing a Terraform provider and managing Vault, and
those differences should be respected and reflected in our processes.

Unfortunately, "it depends" comes with the drawback that it leaves a _lot_ of
room for uncertainty. Which is the best path? Who has the authority to pick a
path? Something has to be done, but how do we decide what? A clearer policy
sidesteps all these issues, especially for newer team members without the
context other team members have, or who don't feel empowered to make that call
themselves.

My job is to turn "it depends" into a policy whenever it comes up for our team.
That doesn't necessarily mean making the policy myself; it could mean that I
talk with the Product Manager and Engineering Manager and the three of us
decide on a policy together. It could mean that the team decides collectively
on a policy. But it is my job to make sure that there is clarity within the
team about what the policy is in our specific context.

## Probably Other Stuff

That's my two things I feel pretty secure about after six months or so of being
an Engineering Lead. I'm hoping for a longer tenure this time around, and hope
I can figure out more of the responsibilities that come with the role, and the
authority vested in me to fulfill those responsibilities.

If you have any suggestions, I'd love to hear them in
[email](mailto:paddy@carvers.co) or on
[Twitter](https://twitter.com/paddycarver).
