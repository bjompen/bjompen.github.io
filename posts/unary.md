# On unary operators

## Long time no write

Again, like so many times before, I haven't really gotten around to write something in a long time.

This "sitting in my couch all day" style of working is taking its toll. But I shan't complain: Having the possibility to work from home is not something everyone can do.

What hit me the hardest is definitely the lack of social interactions. Having a cup of coffee, a lunch date, or just spending time talking in the office.

Me and my teammates have tried to solve this by having regular meetings every morning with no agenda. Sometimes we talk work, sometimes not.

Today is Swedens best and most important holiday: the waffle day, and todays discussion is waffle recipes.

## Yesterdays discussion in our morning meeting

was on unary operators. It turns out they aren't as logical as I thought, and many people in PowerShell don't really know the how and why they do what they do.

The discussion lasted almost the entire day, with people trying to find odd ways of mistreating them,
And in the end I thought "Why not write a short post about them?"

## So let's start at the beginning

### What is a unary operator?

The [wikipedia](https://en.wikipedia.org/wiki/Unary_operation) answer is:

> In mathematics, a unary operation is an operation with only one operand, i.e. a single input. This is in contrast to binary operations, which use two operands. An example is the function f : A → A, where A is a set. The function f is a unary operation on A.

Now had I read math in school instead of playing guitar in the cafeteria that might have made sense to me, But I didn't so it doesn't.

instead, let me try to explain it:

> A unary operation is anything that only takes one variable and does stuff to it. It can be math where you change the value of a variable by one, or changing the value of a Boolean, or invoke a command.

Still not making any sense?

## Let me give you some examples

Many of PowerShells unary operators you will have seen, but might not know they are unary operators.

```PowerShell
# Invoke a command
& $MyVariable

#  negate a boolean
! $True

# dot source stuff
. $MySource
```

These commands all take one variable and does.. something to it.

These are not the ones that peaked my interest though.

```PowerShell
# Adding 1 to int
$i++
++$i
# And removing one
$i--
--$i
```

These are often seen, but not always understood, and they are the ones I will explain.

## The most common use case for $i++

..seen in the PowerShell world would probably be this:

```PowerShell
for ($i = 0; $i -lt 10; $i++) {
    $i # Do stuff 10 times.
}
# Output is 0-9
```

In this command `$i++` is a unary operation, adding one to the current value of `$i`.
The same result would be achieved by using the command `$i = $i + 1`

You may also switch the order of the `++` operator and the variable name to `++$i` and the result would be exactly the same.

```PowerShell
for ($i = 0; $i -lt 10; ++$i) {
    $i # Do stuff 10 times.
}
# Output is 0-9
```

## But Bjompen, why do we have two commands that does the same thing?

Here's where stuff get interesting. Let's set up a different scenario and guess the output.

```PowerShell
$i = 0
$a = $i++
```

What's the value of $a? and $i?

```PowerShell
> $a
0
> $i
1
```

Ok, next test then 

```PowerShell
$i = 0
$a = ++$i
```

What's the value of $a and $i this time?

```PowerShell
> $a
1
> $i
1
```

huh? interesting. But why though?

It's all in the order of reading.

If we read the operand as one thing to do, and the variable as another, it makes perfect sense.

> $a = $i++
<br>Give the value of i to a
<br>Increase the value of i

And on the other hand we have this

> $a = ++$i
<br>Increase the value of i
<br>Give the value of i to a

See! It all makes sense now.

## But it doesn't matter anyway! you already proved it behaves the same in the for loop

In most cases you are correct to think so, but let's add another block of less common but still existing PowerShell code: the do - while.

```PowerShell
$i = 0
do {
    $a = $i++
    Write-Host $a 
} while ($i -lt 10)
```

```PowerShell
$i = 0
do {
    $a = ++$i
    Write-Host $a 
} while ($i -lt 10)
```

Notice the difference in output? First example gives you `0..9`, second example `1..10`.

Now imagine for example indexing an array in this code block. As we all know, array indexes are read using `$MyArr[$a]`, so getting `0..9` or `1..10` makes quite a difference.

## Ok this makes sense, but what about --

well.. logically enough, it does exactly the same but removes one.

```PowerShell
$i = 10
do {
    $a = $i--
    Write-Host $a 
} while ($i -gt 0)
# Output is 10..1
```

```PowerShell
$i = 10
do {
    $a = --$i
    Write-Host $a 
} while ($i -gt 0)
# Output is 9..0
```

## So what does this mean? is there a point to all of this?

Well.. not really, no. I don't have a goal bigger than explaining.

But I haven't written anything in a while and thought it was time to do so, so here we are.

## The day after I started writing this I received mail

You know, old school mail, with a stamp.

It contained a [Raspberry Pi Pico](https://shop.pimoroni.com/products/raspberry-pi-pico?variant=32402092294227) and a [Pico RGB Keybase](https://shop.pimoroni.com/products/pico-rgb-keypad-base).

My inner tinkerer is happy. I have something to do for a couple of days!

I might even end up writing something about it.
