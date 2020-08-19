Disclaimer: Pictures and GIFs are crap here. Deal with it.

So, I finaly got my PI working as expected, and was ready to start testing stuff.
Looking at the examples of the <a href="https://github.com/PowerShell/PowerShell-IoT/tree/master/Examples">PowerShell IoT Github page</a> , Lighting a single led would be a good first test.

In the box of goodies  I initialy had purchased I had five LEDs, 10 different resistors, a breadboard and the cables needed.

Before coding however, there is some knowledge needed:
<ol>
 	<li>What is this GPIO thing?</li>
 	<li>How do I know where to connect the cables on my PI?</li>
 	<li>What are resistors, how do they work, and which one out of the millions available should I use?</li>
</ol>
So lets answer them in order.
GPIO is, to put it simple, the easiest way to interact with any kind of external device.
Connect your thing with one cable to any GPIO pin, and the other end to ground ('GND').
a GPIO pin has two modes you can set it to: High or Low ('On/Off' and 'Up/Down' are other terms i've stumbled accross here, but thats not what <a href="https://en.wikipedia.org/wiki/General-purpose_input/output">Wikipedia</a> says..) 
You can actually read and write data to GPIO, but for our test thats not necessary. 
There is much more to GPIO, but for now that is nothing we need to know.

A great command I discovered pretty early on was 'pinout'
As I understand it, this comes as a part of the package gpiozero, but it seems to be installed by default on Raspbian.
It prints out basic info of your Pi, and the layout of the pins. Please note that <em>they are not in order!</em>
If you connect something the wrong way, bad things might happen.
To make things even more interesting, the WiringPi numbers (that PowerShell IoT uses) is not the same as the numbers on the PI pinout command..
<a href="https://github.com/PowerShell/PowerShell-IoT/blob/master/docs/rpi3_pin_layout.md">A complete map of numbers can be found here.</a>
***There was supposed to be somehing here, but I messed up and forgot to bring theese images from the now deleted old blog. sorry.***

So step one would be two cables to the PI. One GPIO and one Gnd.
***There was supposed to be somehing here, but I messed up and forgot to bring theese images from the now deleted old blog. sorry.***

Next up we need to connect the cables to the breadboard, and a resistor on one side of it.
I googled it, looked at resistor calculator apps and so on, but I dont want google to simply solve my problem, I want to know how to solve it myself.
Nothing made it click until i stumbled on a sign in the store where i bought my things that had the following on it (roughly translated from swedish):
<blockquote>Resistance (kΩ) = ( Source voltage (V) -Voltage drop (V) ) / Power (mA) 
If my Source voltage is <b>12V</b> and i want to connect a LED of <b>3,6V 20mA</b> I need a resistance of <b>0,42kΩ</b>
</blockquote>
<pre class="psconsole">
PS:> (12-3.6)/20
0,42
</pre>
Awesome! Learning instead of just repeating what others told me.

Last lesson to learn was that a LED can be connected backwards. It doesn't work.
After realizing this everything was connected:
Raspberry Pi GPIO18 pin -> Resistance (330Ω) -> LED -> Raspberry PI GND
(This is exactly the same as <a href="https://github.com/PowerShell/PowerShell-IoT/blob/master/Examples/Microsoft.PowerShell.IoT.LED/README.md">the example on GitHub</a>)
***There was supposed to be somehing here, but I messed up and forgot to bring theese images from the now deleted old blog. sorry.***

Fire up pwsh, Import the example LED module and voila!
***There was supposed to be somehing here, but I messed up and forgot to bring theese images from the now deleted old blog. sorry.***

Once one led is working, connecting more and writing small blink script was as simple as 1-2-3,
And so, my first adventure in to PowerShell IoT ended like this:
***There was supposed to be somehing here, but I messed up and forgot to bring theese images from the now deleted old blog. sorry.***

Thats it for my first venture. Next up will be an accelerometer.
I dont have no code from this available on GitHub, as it is already available in the PowerShell IoT repo.
Lessons learned:
Invest in a <a href="https://www.adafruit.com/product/64">real breadboard</a> and a <a href="https://www.adafruit.com/product/2028">breakout cable / cobbler</a>. Its well worth the few $ it costs and makes it so much easier to connect stuff.