Regularity is a good thing, and much needed when starting a blog,
so I was hoping to, at least for now, post one thing every week at least.
I have some plans for a longer post, but it is still far from done,
so instead here is a reminder to myself.

-update: Yes, yes, it took me two weeks to do a monday shorty.. sometimes stuff happens :D

I often get files in random formats that i have to parse and do things with,
Be it reports, statistics, or anything else.
One of the things constantly written in a million ways is dates.
(Dear world, please implement <a href="https://en.wikipedia.org/wiki/ISO_8601" target="_blank" rel="noopener noreferrer">ISO8601</a>)

I was recently given the date format '1705221410', or more specifically 'yymmddHHMMss'.
so, off course, first try is
<code>PS:&gt; $a = [string]'1705221410'
PS:&gt; Get-Date $a
Get-Date : Cannot bind parameter 'Date'. Cannot convert value "1705221410" to type "System.DateTime". Error: "String was not recognized as a valid DateTime."</code>
.. well that sucks.

Fortunately, there is, off course, a DateTime type. Lets explore it.
<code>PS:\&gt; [system.datetime] | gm -Static</code>

<code>Name MemberType Definition
---- ---------- ----------
Compare Method static int Compare(datetime t1, datetime t2)
DaysInMonth Method static int DaysInMonth(int year, int month)
Equals Method static bool Equals(datetime t1, datetime t2), static bool ...
FromBinary Method static datetime FromBinary(long dateData)
FromFileTime Method static datetime FromFileTime(long fileTime)
FromFileTimeUtc Method static datetime FromFileTimeUtc(long fileTime)
FromOADate Method static datetime FromOADate(double d)
IsLeapYear Method static bool IsLeapYear(int year)
new Method datetime new(long ticks), datetime new(long ticks, System. ...
Parse Method static datetime Parse(string s), static datetime Parse(str ...
ParseExact Method static datetime ParseExact(string s, string format, System ...
ReferenceEquals Method static bool ReferenceEquals(System.Object objA, System.Obj ...
SpecifyKind Method static datetime SpecifyKind(datetime value, System.DateTim ...
TryParse Method static bool TryParse(string s, [ref] datetime result), sta ...
TryParseExact Method static bool TryParseExact(string s, string format, System. ...
MaxValue Property static datetime MaxValue {get;}
MinValue Property static datetime MinValue {get;}
Now Property datetime Now {get;}
Today Property datetime Today {get;}
UtcNow Property datetime UtcNow {get;}</code>

hmm.. looks promising.. A few parse methods to try.
I we look closer at the ParseExact Method we can see the following
(HINT: If you type a method, but remove the parenthesis, you get to see what that specific method requires you to put inside.. the Overload Definitions.)
<code>PS:\&gt; [system.datetime]::ParseExact</code>

<code>OverloadDefinitions
-------------------
static datetime ParseExact(string s, string format, System.IFormatProvider provider)
static datetime ParseExact(string s, string format, System.IFormatProvider provider, System.Globalization.DateTimeStyles style)
static datetime ParseExact(string s, string[] formats, System.IFormatProvider provider, System.Globalization.DateTimeStyles style)</code>

So lets break down what we see here:
There are three ways of using this class, requiring different inputs.
As i only want the conversion to be done, lets look at the first one.
The ParseExact method needs the following arguments in this order:
The string that we would like to parse, in our example '1705221410'.
The string to decide what value equals what, again, in our example 'yyMMddHHmm'

The last one is somewhat more tricky.
System.IFormatProvider is, simply put, a way of saying 'we need to know how to interpret this'.
Or, as MSDN says it: <a href="https://msdn.microsoft.com/en-us/library/system.iformatprovider(v=vs.110).aspx" target="_blank">Provides a mechanism for retrieving an object to control formatting.</a>.
Most common I find that what you need here is some kind of cultural info (how to show numbers, dates, separators and such), but the best way to be sure is, as always, <a href="https://msdn.microsoft.com/en-us/library/w2sa9yss(v=vs.110).aspx#Remarks" target="_blank" rel="noopener noreferrer">search MSDN.</a>

So now we can see that we need one of the following:
A CultureInfo Object
-or
A DateTimeFormatInfo Object
-or
A custom IFormatProvider
-or
'If provider is null, the CultureInfo object that corresponds to the current culture is used.'
That last one looks good. we do, after all, want to see dates the way we normally do.
So lets try it:
<code>PS:\&gt; [System.DateTime]::ParseExact('1705221410','yyMMddHHmm',$null)</code>

<code>Monday, 22 May, 2017 14:10:00</code>

Success! but you are never satisfied until you know the details, so lets try with different ways of using it as well:
<code>PS:\&gt; [System.DateTime]::ParseExact('1705221410','yyMMddHHmm',[System.Globalization.DateTimeFormatInfo]::CurrentInfo)</code>

<code>Monday, 22 May, 2017 14:10:00</code>

<code>PS:\&gt; [System.DateTime]::ParseExact('1705221410','yyMMddHHmm',[System.Globalization.CultureInfo]::GetCultureInfo('en-US'))</code>

<code>Monday, 22 May, 2017 14:10:00</code>

Both seems to work fine!

So, now that we can do this, lets try it with even stranger strings.
<code>PS:\&gt; [string]$today = 'year 2017 and date 30 and month may and time 9 00'
PS:\&gt; [string]$pattern = '\year yyyy an\d \da\te dd an\d \mon\t\h MMM an\d \ti\me H mm'
PS:\&gt; [DateTime]::ParseExact($today, $pattern, $null)</code>

<code>Tuesday, 30 May, 2017 09:00:00</code>
Awesome. Quite a long Monday shorty, but at least i posted something.
Next time i hope to present a project i am working on.
Nothing fancy, but it is a fun little home project.
Until then, keep coding, and remember:
If you´ve done it twice, it should be automated.

Todays readworthy links:
<a href="https://msdn.microsoft.com/en-us/library/w2sa9yss(v=vs.110).aspx" target="_blank">DateTime.ParseExact Method</a>
<a href="https://msdn.microsoft.com/en-us/library/system.globalization.datetimeformatinfo(v=vs.110).aspx" target="_blank">DateTimeFormatInfo Class</a>
<a href="https://msdn.microsoft.com/en-us/library/system.iformatprovider(v=vs.110).aspx" target="_blank">IFormatProvider Interface</a>

//Bjompen