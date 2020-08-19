Good morning internet!

If you don't already do this, 
you should start reading <a href="https://www.reddit.com/r/PowerShell">/r/PowerShell on Reddit.</a>
Many good questions ranging from total beginner to extremely advanced,
and you get to see problems you never knew other people had.

I try to help out there every now and then,
but mostly someone else beats me to it.
No fake internet points for me.

Today, like many times before, someone asked for tips about ping or similar commands,
so I thought I’d do a blog post about different ways to do it, and do some measuring as well!

Let’s start by checking different methods to do this.
In PowerShell there is a well-known command, Test-Connection, that most of use and love.
Simply put, it is equivalent to CMD's ping, but with added PowerShell glory.

Next up is a somewhat lesser known one, Test-NetConnection.
This command gives you a little bit of different possibilities and results,
like setting target port (for testing stuff like www, ftp..), tracerouting etc.
<a href="https://technet.microsoft.com/en-us/itpro/powershell/windows/nettcpip/test-netconnection">More info on MS website.</a>

Third (and forth) will be the .net class <a href="https://msdn.microsoft.com/en-us/library/system.net.networkinformation.ping(v=vs.110).aspx">System.Net.NetworkInformation.Ping</a>

I set up a quick test environment using four external known hosts that reply to ping.
<code>[string[]]$address = '8.8.8.8','8.8.4.4','4.2.2.2','4.2.2.1'</code>

And just to make sure all of them are actually available, lets test it first.
<code>$address | foreach {Test-Connection $_ -Count 1}</code>
Well, looks good. Let’s see how much time this takes.
<code>PS> Measure-Command -Expression {$address | foreach {Test-Connection $_ -Count 1}} | Select -ExpandProperty Milliseconds</code>
<code>95</code>
95 milliseconds.
After doing this 10 times I get between 95 and 105ms.

Does Test-NetConnection beat it? let’s see!
<code>PS> Measure-Command -Expression {$address | foreach {Test-NetConnection $_ }} | Select -ExpandProperty Milliseconds</code>
<code>347</code>
Whoa! nope, no, njet!
Again, after 10 or so times, average is between 250 and 350ms.
If you are only interested in ping results, avoid this.

So let's go all in.
We already know using classes are almost always faster,
but it´s not knowledge unless tested.
First up is using good old ping.
<code>PS> Measure-Command -Expression {$address | foreach {[System.Net.NetworkInformation.Ping]::new().Send($_)}} | Select -ExpandProperty Milliseconds</code>
<code>75</code>
Yupp. It's faster.
average after 10 tests is 69 to 75ms.

So let’s test one more.
[System.Net.NetworkInformation.Ping]::new() contains a method called SendPingAsync()
Normally, you wait for one ping to return, before sending the next one,
but using async we can send them all at the same time, and just await the results.
This is blazingly fast, but it takes a bit of more code to handle.
As it sends the ping request to a background job,
you have to explicitly tell PowerShell to wait for it to finish.
Let’s try.
<code>PS> Measure-Command -Expression {$a = $address | Foreach {[System.Net.NetworkInformation.Ping]::new().SendPingAsync($_)} ; [Threading.Tasks.Task]::WaitAll($a)} | Select -ExpandProperty Milliseconds</code>
<code>39</code>
39ms. Again, 10 tries average 39 to 49ms.
After this, you can use your variable ($a in my case) to check the actual status of your servers.

Final result:
1. SendPingAsync() ~40ms
2. Ping() ~75ms
3. Test-Connection ~95ms
4. Test-NetConnection ~347ms

So, is there a point to all this?
Well, I only tested four servers and there was already a massive speed difference.
No go run this test on a park of thousands of servers.

I highly recommend you read <a href="https://learn-powershell.net/2016/04/22/speedy-ping-using-powershell/">Boe Prox blogpost on speedy ping!</a>,
because we all know you can’t have too many tools in your toolbox. 

As for me? I think I have to learn how to write code in a blog post.
I wonder if someone has written a blog post about it..