# Todays topic: Nothing

I've been inactive for far to long and feel like I need to write something, yet I have no idea what to write about.
Normally I'd just pick the last thing I worked on that I found cool, but I have some issues with it: About a mnth ago my Azure DevOps subscription went titsup.

I'm not saying it's connected, but it was pretty soon after I complained about [Azure Chaos studio](./AzureChaosStudio.md) and told the world about [the amazingly odd yet cool apis in Azure DevOps](./SomethingAmazing.md).

![Seems just a little crazy, doesnt it?!](../images/NothingNew/crazy-conspiracy.gif)

So whats going on?
- I can't get any agents started in my AZDO organization. None.
- I've spen't way to much time posting useless logs to [my issue over at the DevOps forums](https://developercommunity.visualstudio.com/t/hosted-agents-hang-with-pool-provider-s/10152498)
- I'd give a beer to the person who hooks me up to someone in the Azure DevOps team who.. well.. knows what they are doing.

## So what have I been doing?

This is just as much for me as for anyone else who cares, But I need to remind myself I haven't been all useless.

### Sessions!

- I've sent proposals to a number of conferences, but to no avail so far. Giving up would be the easy thing to do after a number of "no thank you"´s, but I'm not there yet. I have at least three or four more sessions waiting for a reply. (sidenote: [This](https://callfordataspeakers.com/) is an amazing site, and I want to thank [Rob](https://twitter.com/sqldbawithbeard) for mentioning it!)

### I _am_ doing some presentations though!

- [Azure User Group Iceland](https://www.facebook.com/groups/azugis/), 4:th of november, 12:00 CET, "Infrastructure as code using Azure DevOps and Bicep"
  -  I will be doing a presentation on getting started with Bicep and infrastructure as code. Well.. Since My Azure DevOps environment is f***ed I am doing this is GitHub instead.. If I manage to get it all in place.. _#Nervous_

- [Cloudrunner](https://www.eventbrite.com/e/cloud-runner-2023-1895-sek-per-person-tickets-423982933367?aff=ebdsoporgprofile), 22:nd of november, "Azure DevOps pipelines- Från dig till molnet"
  - Again, since my Azure DevOps is.. well yeah, you get it..

So I have been spending _a lot_ of time writing PPT and demos for theese, and will continue to try to figure out how to get my DevOps env. working to get these going.

## research and learning

Of course learning wont stop because my environment stops.
Like I said, I will redo some, or all, of my demos in GitHub instead, and that's quite a learning curve.
I find the "GUI" and general layout around the GitHub Actions eco system highly confusing and lacking to be honest. Most likely just because habits, but things like finding related help documents ("ok, I need to add a token, but what token? and where do I find docs around that?"), or finding standard actions (searching for "PowerShell" gave me loads of actions called "PowerShell", none of them mady by Microsoft.. turns out you need to search for "shell" and select "PowerShell" there.. )

I will probably do a small write up on GitHub actions vs. Azure Pipelines sometime when I'm done with this.

I've also spent some time on destructuring and figuring out how the Azure DevOps VMSS extension works behind the scenes. That turned out to be harder than expected honestly, and in the end my good friend and coleague Sebbe Claesson figured this one out. I hope whe does a write up on it [on his blog](https://sebastianclaesson.github.io/), but if he doesn't, thats one more for me to do 😉

## Code

There's been quite a lot of code written as well.
I finished the "Increase test coverage" cycle of [ADOPS](https://github.com/AZDOPS/AZDOPS) (Yes, we're aware of the AZOPS / ADOPS discrepancy, but shush.)
100% test coverage is not a measurement actually worth anything, but it gives me a pointer I have a pretty good coverage at least. In the same cycle I also rewrote most of the tests, the testrunners, and learned _a lot_ about scoping thanks to my friend and coleague [John Roos](https://blog.roostech.se/)

I have also worked on improving [PSSecretScanner](https://github.com/bjompen/PSSecretScanner)!
Added loads of new patterns, and currently refactoring just about all of it from scratch together with [James Brundage](https://twitter.com/JamesBru) to improve output, and make it more "PowerShell-y". A GitHub action is also comming to this one soon, so you can just add it and autoscan your pipelines right away. Good stuff!

Last, but absolutely not least:
I got a PR approved in the [bicep repo](https://github.com/Azure/bicep/pull/8418)!
Sure, this is a simple fix, but I feel proud for finding the bug, reporting it, fixing it with some great help from another friend and coleague: [Emanuel Palm](https://twitter.com/PalmEmanuel), and figuring out how to write testcases for it.

## IRL

There have been stuff going in the outernet as well. Most famous would be a swedish election where right wing took power, and a bunch of proper racists became second largest party of sweden. Let's just say it took a couple of days to melt that. Apparently 80 years is the timespan of "never forget"..

Less famous, but more fun would be that the season of berries, fruits, and mushrooms are over us in Sweden, and I have been spending a lot of time walking the dog, picking raspberries and blackberries, apples, and chantarelles, and making pickles, lemonades, and jams. good times.

## In the end

I guess what I'm saying is this: I ain't dead yet, and hopefully the blogging isn't either..
I just need some time to do other things.

Like fixing my f***ng Azure DevOps organization.
