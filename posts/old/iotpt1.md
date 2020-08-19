Disclaimer, This is jut a prequel, no code is here. If you are just curious about how to get going, read chapter two directly.

Summertime is upon us, and I am in the middle of vacation.
Swedish weather right now is pure terror with forest fires, no rain and I am spending most of the days in the couch just trying to cool down.
What could be a better way than some code?

This spring Microsoft released Powershell IoT,
And there was some presentations of it at PSConfEU.
Since I have a Raspberry Pi, I thought this would be an interesting project to check out, And so, the summer project was decided.

At first I decided something I wanted to automate at home:
I have a crock pot. A cheap one without temp controll and automatic turn off, but it does its job.
If I could get my Pi connected to a temp sensor, using a needle in the food beeing prepared,
My plan was first to set a temerature alarm, but soon I realized I could connect it to a powerswitch,
and automatically turn the Crock Pot to off when meat reaches $temp.
Project one was designed.

Before I started messing with the project itself, I realized I would have to check out how PowerShell IoT works,
so i bought some cheap sensors (temp/humidity and acceleration), a bunch of leds, resistors, cables and a breakout board for design and connections.
All of this added up to a sum of about 20$. IoT stuff is cheap! =)

Good to go, I hit my first hurdle:
I haven't installed or ran Linux in years.. how do this work?

I started by installing Raspbian, the default Raspbery Pi Operating system.
You can find raspbian here: <a href="https://www.raspberrypi.org/downloads/raspbian/">https://www.raspberrypi.org/downloads/raspbian/</a>
I opted for the desktop version. Why? Easier was my guess.

Secondly, We need to put it on a SD card.
I had a 16Gb card spare, so I used that one, connected to my laptop, and installed the image downloaded using Etcher, found here:<a href="https://etcher.io/"> https://etcher.io/</a>
All of this is documented fairly well on the Raspbian page, and was very simple.

Throw the SD card in to the Pi, and off we go. I thought.
I started by installing PowerShell for Raspbian. I picked the correct version from <a href="https://github.com/PowerShell/PowerShell">https://github.com/PowerShell/PowerShell</a>,
Downloaded it, followed the instructions, and... nothing worked any more.
I ran out of diskspace.
Turns out the default raspbian image only has a 4 gb partition, the rest of the sd card is left unused.

Reinstall, and try again in chapter two.