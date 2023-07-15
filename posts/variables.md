# Variables - A lesson in powershell behaviour.

WTH IS GOING ON?! TWO POSTS IN A DAY? 

After a year of silence, 4 posts in a week?

Well this is just a short one.

## While creating the [Set-AzDoPermission](posts/holdmydecompiler.md) function

I stumbled upon an interesting "bugg", and I thought it interesting to write about.

## I have the following in my VSCode window

![URL](..\images\variables\a.png)

My linter, PSScriptAnalyzer, considers everything ok as we can see from the colouring, yet when I select it and click `F8` (run in VSCode) I get the following error:

![Error](..\images\variables\b.png)

All my variables are set correct, yet when something weird is happening to my URI...

![Expanded](..\images\variables\c.png)

## So what happened to `$RepoName?api`?

Well here's a bit of PowerShell fun...

In reality, the terminology `$VariableName`is not the coorect way to call a variable according to PowerShell.
Someone, somewhere, decided however it would make sence to allow us to call them this way anyway.

The problem I encountered is this:

## What characters are ok to have as a variable name?

Well for example, alphanumeric characters and `?` are allowed.

`-` however, isn't.

### The result?

Instead of interpreting `$RepoName` as a variable name, PowerShell actually interpreted the entire string `$RepoName?api` as the variable name.

## The sollution

The "Correct" way to call a variable in powershell is actually to use `{}` to wrap the variable name, so instead of `$RepoName` we use `${RepoName}`

![Correct](..\images\variables\d.png)

and BOOM! No errors!

![Working](..\images\variables\e.png)

## That it for todays PowerShell lesson

See you next time.

//Bjompen
