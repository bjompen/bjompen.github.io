# A quick note on Azure functions

## I will not rant today. Promise!

No, really, I tend to write way longer than I plan to do, but this time I just want to make a not to myself so I'll remember this for next time.

## I work a bit with Azure functions

I have colleagues who has written some really brilliant blogposts on the whats and hows to do this, so I'm even going to skip this part.

## What I need to remember though

Is this: An azure function Managed Identity created through the GUI doesn't seem to have any way of adding rights to it.

Normally you'd do this using the "App Registrations" button in Azure, but it won't show up there.

If you by chance add Authentication using the newer Authentication version on you Azure function, this will create a managed identity as well, but this is not the identity you're looking for.

The result of adding both "Authentication" using Azure, and a Managed Identity, Is that you will have two Enterprise apps named the same thing, and only one of them (the wrong one) under App Registrations.

## To grant access to graph

for your managed identity, you have to use powershell or az CLI.

Bonus thank you to [Simon Wåhlin](www.twitter.com/SimonWahlin) for helping me learn this, and writing the code.

[You can find it all here](https://blog.simonw.se/azure-functions-and-azure-ad-authorization/)

### EOL
