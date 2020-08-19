Happy Monday!

Yes, I know, it´s Wednesday, but yesterday was <a href="https://en.wikipedia.org/wiki/National_Day_of_Sweden">the national day of Sweden</a> so this is, in fact, the first workday of the week.
Let´s just say 'Monday shorty' was probably not the most thought through topic I could have chosen.

Anyway!
How many times have you seen this?
<code>PS:\> $string
abc
PS:\> $string -eq 'abc'
False</code>
Or maybe even this?
<code>PS:\> '^C' -eq '^C'
False</code>
I know I have run in to it a lot of times,
And I have also answered the question on both Facebook and Reddit,
so Here is my solution to the question:
'What´s in that string?'

Simply convert it to a char array,
and pipe it to a foreach loop converting each char in the array to an int!
<code>PS:\> $string.ToCharArray() | ForEach-Object -Process {[int][char]$_}
97
98
99
32</code>
Ok, I understand if you don’t speak int fluently, 
So <a href="https://simple.wikipedia.org/wiki/ASCII">Here is Wikipedia’s list of ASCII chars</a>.
And lo and behold, a trailing space!

Oh, the other one? Those are, after all, the same characters, right?
<code>PS:\> '^C'.ToCharArray() | ForEach-Object -Process {[int][char]$_}
3
PS:\> '^C'.ToCharArray() | ForEach-Object -Process {[int][char]$_}
94
67</code>

Simple, but useful, just how I like it.

See you next "Monday"

//Bjompen