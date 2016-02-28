+++
date = "2013-03-26"
summary = "When is cleverness a good thing in software? Where is the appropriate place to be clever?"
title = "Oh, The Cleverness Of Me"
url = "/posts/cleverness"

[quote]
attr = "Edsgar W. Dijkstra"
text = "The competent programmer is fully aware of the limited size of his own skull. He therefore approaches his task with full humility, and avoids clever tricks like the plague."
+++

For quite some time now, I have vocally denounced clever programming tricks.

Yes, yes, your one-liners are cute. But bytes are cheap and I _need to read that, goddammit_, so please stop obscuring what the software actually _does_. The correct syntax to use, in my humble opinion, is always the syntax that most clearly demonstrates what you are trying to achieve.

{{< highlight ruby >}}
y = if x ? 1 : 2
{{< /highlight >}}

That makes me cry. Please don’t do that.

{{< highlight ruby >}}
if x
    y = 1
else
    y = 2
end
{{< /highlight >}}

See how much clearer that is?

And I thought this was a pretty straight-forward stance on the issue: clarity good, clever tricks bad. It’s the reason I dislike Ruby so much; the community seems to revel in writing code that is impossible for a reader to decipher without carefully picking through it. On a related note, whoever thought letting statements come before their conditionals was a good idea makes me sad.

{{< highlight ruby >}}
puts "Hello" if x
{{< /highlight >}}

But then, as I was thinking about Go, C, and the early innovators of computing, I became conflicted. Because so much of what they did was clever. I admired those people, I aspired to be like them, and it threw me pretty badly to realise that they were clever.

So I had a conundrum on my hands: when is it appropriate to be clever with code?

## The Golden Rule

The solution I fell back on, after some internal turmoil over the issue, was that cleverness itself is not bad. Cleverness _for the sake of cleverness_, however, is something that should be avoided at all costs.

The difference between channels (which I find to be a very clever solution to a problem raised by concurrent programs) and the Unix Way (which is an exceedingly clever way to build a workflow, especially for the time it was developed in) compared to clever one-liner hacks is that the cleverness I admire is clever _in the pursuit of clarity_.

Yes, channels are a clever solution to the problem, but they also clarify the programs being developed. Reversing the order of the conditional and expression, however, does not make the program clearer. It helps the program read more like English, yes. But we do not want programming languages to start emulating English. I’m familiar with the English language to an absurd degree. Just take my word on this one. It is an ugly, bloated thing, and it is poorly suited for the task of expressing precise and complex ideas with the clarity a compiler requires.

**TL;DR**: cleverness is only ever justified if it makes the structure and behaviour of your program clearer. Clarity is king, not concision. Keystrokes are cheap compared to the amount of effort it requires to read your obfuscated code.
