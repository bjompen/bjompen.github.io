# AI. A Continuation

Again to long, again to much, yet always the anxiety of thinking I am doing to little. Thank you imposter syndrome.

This years primary focus so far has been writing presentations. Normally that would be some half of my time or similar, but because of reasons I am lagging behind and have not prepared my [PSConf sessions](https://psconf.eu/) nearly as well as I'd wish.. But the reasons are fun.

The year started with a move. Bought a house, and moved in march. Garden, growing plants, beers on the patio, the full monty. The non-computer life is amazing, but takes a lot of time.

Apart from this my band, [Internal Decay](www.internaldecay.com), released an EP - our first in 30 years - and is working full time on a full length and being well prepared for live performance. 

All good fun.

But thats not why I am writing again.

## I have a confession to make

I have used AI coding tools. 

In the end of 2025 I stumbled upon the release of [Midi 2.0 for Windows](https://microsoft.github.io/MIDI/). The musician in me got interested. Not that Midi in itself is something new and fancy, it's actually older than Windows (and almost as old as me), and truth be told - most of the [new protocol features](https://midi.org/midi-2-0-core-specification-collection) I will probably never use or notice I am using.

No, the main reason it was interesting is that it is developed in .Net 10. So is PowerShell 7.6. 

This means I can use all of the Midi 2.0 SDK natively in PowerShell. 

This means I can use PowerShell as a really crappy midi player / Daw / Keyboard input.

Now, I am well aware of how potentially useless this is - But as with almost everything I do it is about learning. A chance to learn more about music and a chance to learn more about PowerShell. There are two main outcomes of this little adventure:
- [A PowerShell module for midi stupidities](https://github.com/bjompen/PSMidi)
- A presentation at PSConf EU called 'Musical PowerShell - Make your scripts sound awesome!'

So what does all of this have to do with AI? IS the module [vibe coded](https://en.wikipedia.org/wiki/Vibe_coding)?

Nope. But it did help me.

## On protocols and the art of the spec

I have never worked with midi before. I have _used_ it for drums, keys, and a lot of other stuff, but never looked at how it works. So the first thing this module creation required was for me to understand _what is actually going on_.

The Midi protocol spec is actually fairly short.. Depending on your definition of short of course. [Midi 1 spec](https://midi.org/midi-1-0-detailed-specification) is a 58 page document, and the [Midi 2 spec](https://midi.org/midi-2-0-core-specification-collection) is an additional 85 - excluding appendixes. There are a lot of cross references in the vein of "This works like it did in Midi 1.0", so reading both was needed.

Most of the things I actually care about is surrounding packages and their format. Formating a midi 2.0 package is basically a process of building two 32 bit envelopes, containing 8 different binary data blocks of different sizes. If you have never used the -bor, -band, and -bxor operands in PowerShell before this is a good lesson. Convert these packages to hex, and send to the Midi connection.

Not gonna lie, it took a lot of time ang google to figure out, but it is doable. 

But after I got this working I had another idea... The midi file format! If I can parse a midi file and convert it to my midi module, then I should be able to play a midi file through PowerShell. Not only cool and rather useless, but also one more chance of learning.

And this, dear reader, is where I used AI.

## The edge of brain power

Of course, since midi is an open protocol, the [file spec is also available online](https://midi.org/standard-midi-files). And I read this. Again. And again. And I could not make sense of it. I understand the words, but how do I translate this in to code? And all these packet headers and locations and datasizes.. My brain just couldn't get around it.

But as an MVP I do have some goodies given to me. One of them is a rather decent CoPilot license with a bunch of models.. 

And so it was I asked Claude to "Create a midi .mid file format parser in PowerShell that reads the file and outputs all packages and streams as PowerShell objects" (or someting to that ilk). Now I know code generation is a hit-or-miss, and lots of generated code is crap, but the midi file spec is open and there are a million readers out there to train on. The worst thing that could happen was that it fails.

But it didn't. Suddenly I had a working implementation that I could read. I could use it to parse files where I knew the contents (beats, notes, etc.) for me, and compare the result with the spec.

Suddenly it made sense. It was so much more easy to understand the specification when it was explained in a language I knew.

And it got me thinking of the actual point of this post.

## Back to basics

When I grew up I had a Comodore C64c. It was amazing. It played games. And it had Basic.

I have _always_ claimed basic is an amazing programming lanugage, and I have been on the edge of being punched in the face for it. I teaches you bad habits. It has the notoriously terrible "goto" command. It is not a real programming language. There are endless things people have said about it, but no one has been able to convince me otherwise. Why?

It is pure and simple English.

I did not know how to write code, but in school we were tought English. Sure, I had to get the basics of basic somewhere: The format (Line numbers ftw!), variables - although I didn't know thew were variables - to me they were "dollars", but once that was in place I could almost guess the next thing. In fact - I remember thinking "if PRINT writes things, and PRINT means skriv in Swedish, and the word INPUT is in th code, that translates to 'läs in', so this line probably will ask me for something". I went on to write a basic program to get the current year and the year I was born, calculate the difference and output "Your age is A$". And by god was I proud!

Forward some years, I get my second PC (yes second, the first one didn't have a colour screen) and qbasic. Again exploring. How do I draw a circle? lets try writing "circle"! But I want it to have a different colour.. Lets try "color" (misspelled, curse you americans!). 

The point is - it was.. well.. basic. Easy. A Swede with limited english language could get started with code.

The whole process was closer to that of the tinkerer than a programmer. I wanted to know how stuff worked - I didn't care for standards.

And this is actually where I can see AI as a usefull tool.

## "But Bjompen, there are simple languages!"

Another thing I have been told a million times. For some reason most common, anecdotally, Python is mentioned a lot as a good "starter" language. Sure. You just have to set up an entire developer environment, install the correct version (2 or 3?), find and download the packages you nee...oh wait, we need to conifgure PyPi first, write code to print stuff, realize there should be parenthesis for some reason, count the spaces.. By now Bjompen, 8 years old, would have left to play north and south ten times over.

"But there are tools made for this like scratch!"

Have you used Scratch? I have. I have tried it with my kids, and in classes. I have never heard anyone enjoy it. It's a mess of a GUI with no real point to it. In fact, if you want GUI drag-and-drop programs go look at [Microsoft Kodu](https://www.kodugamelab.com/). It is a million times better and more entertaining. The problem is still that none of them teaches curiosity. It's theory.

## Enter AI

So do I think AI is filling the gap of Basic? Well.. No, but it does _allow_ for the gap to be filled. Because just like when I was 8 and discovered INPUT commands, having a short, generated code that got me over the hurdle of understanding helped me discover. Once I had the original midi file spec translated I could start changing the output. I could alter the packet to do what I wanted or to try what happens if I... I could change the CIRCLE command in to a LINE and lo and behold - I drew a line on the screen!

And I _do_ think this is the gap we _should_ look in to AI to fill.

If, instead of looking at AI as a replacement for entry level programmers, and instead of using it to convert programmers to bug fixers, we look at AI as a tool that can enable a tinkerer - a curious person - to get over the initial hurdle and learn, then suddenly it may actually give us good programmers as an en result simply becuse we don't require a university diploma just to get the basics up and running.

Now just like basic _does_ teach bad habbits, AI does generate bad code, but I do belive removing the complexity of programming - even at the cost of good code, can be an eye opener. Once AI has generated the code to read input, we can see how to do math, calculate the age and output.. And think "hey, the computer already knows what year it is - I wonder if I can get that instead".

## Unfortunately though...

This isn't how it is. Generated code still needs to be compiled or have some kind of scripting engine. And it still requires me to figure out PyPi or NPM or the PowerShell Gallery. Not to mention it requires a lot of money for token-burning - Something few 8 year old curious tinkerers have. All combined - hurdles between me and the joy of seeing a line on the screen thinking "I did that! All by myself!".

Not to mention the tech-bros will keep claiming AI can solve everything, C-levels will still see it as the key to firing more devs and not hiring juniors, all the while training engines will burn the earth to sell one more CoPilot and keep the hype machine alive.

Shame on what is, in essence, some _really cool technologies_.

But I can hope. Maybe one day people will realize we need a new BASIC revolution.

## End rant

So - Like I said in my previous rant - I absolutely am not 100% against AI. I am 100% against the name, and I am against the missuse of it, but I can see places where it fits.

And Ever since I started looking at it as BASIC instead of actual code generated I actually have changed my mind a bit on usage. I still don't think you should release code withouth _knowing_ the code, and vibe coding is a terrible practice, but generate, itterate, and learn - and in the end write the functionality you want to.

And that journey is still going on. I need to finish that midi file parser using _my own_ words. Eventually it will be out there:

The most useless and crappy DAW in the history of DAWs.

Until then, sleep well internet.
