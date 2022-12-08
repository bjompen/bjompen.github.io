# Defender for DevOps and MSDO - An introduction

## Last couple of weeks has been hectic

In more than one way. I've had no less than three presentations (two user groups, and one conference),
and I've also made the switch from blue bird site to [mastodon](http://mastodon.nu/@bjompen).
This switch might not seem like much, but it is. I've spent years building my network over at the bird site, and have a significant part of the people I like there.. Yet ~~the cunt with burning cars and stupid tunnels that makes no sense and stealing ideas form actual inventors and bullying and....~~ Ol' Musky was too much for me. Porn, Spambots, Nazis, and other stuff he let in simply isn't worth my mental health.

But let's not get too political. If you want my opinions of those things, ask, I'll gladly talk about them elsewhere.

Back to the presentations.

## Two of my presentations was on Defender for DevOps and MSDO

And that's what I plan to write about today.

Some time ago I, along with a bunch of colleagues, went to Ignite in Seattle. I wrote about it [here](./ignite2022.md) in not all positive words, but like stated I did go home with a couple of things worth researching. Defender for DevOps being one.

## I often say I'm not a security person

And that I still stand by, but since I work a lot with pipelines I naturally stumble on to this topic anyway.

There are a [number](https://owasp.org/www-community/Source_Code_Analysis_Tools) [of](https://owasp.org/www-community/Vulnerability_Scanning_Tools) [tools](https://owasp.org/www-community/api_security_tools) available already to have in your pipelines. Some to protect your code, some to protect your target deploy, and some to make sure you follow best practices. There are even really good tools to [scan for secrets](https://github.com/bjompen/PSSecretScanner/) and some videos on [securing your pipeline](https://www.youtube.com/watch?v=-C9fb8Jm9qw) 😉

Yet all of these tools require quite a lot of setup.

- Some requires accounts.
- Some requires you to "send" your code somewhere for scanning.
- Some costs money.

Enter: [Defender for DevOps](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-devops-introduction)

## What is Defender for DevOps?

Well, If you've previously used MS Defender you might guess - It's a security tool with some nice reports and stuff. We _will_ look at it, but honestly, I find MSDO, _Microsoft security DevOps_, the pipeline part of it more interesting, so lets start there.

MSDO is a tool that scans for things like

- Bad settings in Infrastructure as Code such as Bicep, ARM, and Terraform.
- Accidently exposed secrets
- Badly configured container images
- [and more...](https://learn.microsoft.com/en-us/azure/defender-for-cloud/azure-devops-extension)

In short, it does what many of the tools above mentioned does. In fact, it even uses many of those tools behind the scenes.

So what makes this different? Well lets go have a look, shall we?

As always, I work in Azure DevOps, but almost everything I do here can also be done in [GitHub](https://github.com/microsoft/security-devops-action) as well.

## Setting up the prerequisites

The first thing we need to do is to actually install the plugin. This gives us access to the pipeline step, and allows us to make it all as easy as it should be.

In your Azure DevOps organization, top left, you have an image of a suitcase. Clicking this button shows the options to browse the marketplace and manage extensions.

![Extension button](../images/azure.defenderfordevops/1.png)


Go to the marketplace, search for, and install the following extensions

- Microsoft Security DevOps
  - This is the actual tool we're going to use
- SARIF SAST Scan tab
  - This is an extension to show the test results a bit nicer.

Once you've done so, click the button again and go to "Manage extensions" and you should see something like this:

![Installed extension](../images/azure.defenderfordevops/2.png)

Good! We're ready to start using MSDO!

## Setting up a test repo

For the sake of demo I have prepared a repository with a number of files:

- Docker file, K8s manifest, java script file, python code, and Arm template from the [security devops samples](https://github.com/microsoft/security-devops-action/tree/main/samples)
- [licecap.exe from cockos](https://www.cockos.com/licecap/) (absolutely fantastic, yet old and therefore not compiled with all the modern fancy stuff, tool for Gif creating!)
- TestSecret.txt containing a number of "secrets" such as passwords and ssh logins.
- badly configured StorageAccount.bicep I used for a demo once 😉

In total my repo looks like this

![Repo contents. Basically just showing the above mentioned file.](../images/azure.defenderfordevops/3.png)

This should be enough to trigger just about every tool with some data, so lets get going!

## My first pipeline

Like I stated in the beginning many of these security tools can be hard to get started with. MSDO is no exception. It's super hard.

In our repo, lets create a starter pipeline by clicking the big blue button "Set up build"

![set up build button](../images/azure.defenderfordevops/4.png)

Pick "Create a starter pipeline", give it a good name, and put the following yaml in there:

```yaml
trigger: none

pool:
  vmImage: windows-latest

steps:
- task: MicrosoftSecurityDevOps@1
```

Done! That's it. All you need.

Some explanation might be good here:

- I didn't set any trigger because it makes it easier to lab around it
- We "need" to run windows latest as some tools seems to require non default config to run on ubuntu. more on that later.
- The task will run, and it will run most of the available tools with default settings.

We should of course give it a fancy display name, and there are actually some requirements we need to install as well, so lets make it a bit better before we click "save and run".

```yaml
trigger: none

pool:
  vmImage: 'windows-latest'

steps:
- task: UseDotNet@2
  displayName: 'Use dotnet'
  inputs:
    version: 3.1.x

- task: UseDotNet@2
  displayName: 'Use dotnet'
  inputs:
    version: 6.0.x

- task: MicrosoftSecurityDevOps@1
  displayName: 'Microsoft Security DevOps'
```

> Note: according to [documentation over at MS learn](https://learn.microsoft.com/en-us/azure/defender-for-cloud/azure-devops-extension#configure-your-pipelines-using-yaml) we also need to include .net version 5, however according to [the documentation at GitHub](https://github.com/microsoft/security-devops-azdevops#dependencies) .net 5 _isn't_ needed. From my testing so far GitHub is correct, and we do not need to include version 5 for now at least.

Lets click "Save and run" and see what we end up with!

## Exploring the results

![First pipeline run results](../images/azure.defenderfordevops/5.png)

Looing good!... Or... well.. bad. Which is good.

I've included the entire log file of the MSDO run [here](./azure.defenderfordevops.1.log) if you're curious,
But for now, let's go explore what it looks like in the pipeline run, shall we?

![Pipeline run summary showing errors from MSDO](../images/azure.defenderfordevops/6.png)

A couple of interesting things worth noting here:

- Yes, we see the errors in this view just as expected, yet it is only binskim errors here when we should have.. more?
- No artifacts are created (Yes, we have no artifact step set up, but this is relevant. Bear with me 😉)
- There's a "Scans" tab next to the summary.

The Scans tab comes from the SARIF SAST extension we previously installed, and it will automatically catch all artifacts containing .sarif files and build reports from them. The MSDO extension is supposed to automatically create these artifacts, but there appears to be an issue in the extension where if a terminating error is output to the pipeline that is _not_ related to the scans itself it fails to create this .sarif file. [There is an issue created on it, so please go upvote it in order to get this fixed](https://github.com/microsoft/security-devops-azdevops/issues/22)

Our binskim run, from my best guess, fails because it tries to to load debug information from a pdb file (or something like it.. I not a c# dev).

```Text
D:\a\1\s\DFDOFiles\licecap.exe : error ERR997.ExceptionLoadingPdb : 'licecap.exe' was not evaluated because its PDB could not be loaded (E_PDB_NO_DEBUG_INFO).
```

Since this breaking error comes from binskim, lets start our deep exploring by fixing it!

## The .gdnconfig file

Like most applications and pipeline steps there are more than meets the eye. Yes, getting started is dead easy, but we can, and in many cases want to, configure stuff.

The standard way of configuring settings in MSDO is to use a .gdnconfig file, which is in fact just json with a custom file extension.

We can start here by simply adding it to our repo and pipeline like this:

```yaml
- task: MicrosoftSecurityDevOps@1
  displayName: 'Microsoft Security DevOps'
  inputs:
    config: 'gdnconfig/.gdnconfig'
```

![Git folder structure with added ..gdnconfig file](../images/azure.defenderfordevops/7.png)

The content of this file follows a rather simple structure using the headlines "tool" and "arguments".
Tool is, logical enough, the tool we're configuring. We can set the name, and if needed also lock a specific version of a tool here.

The best source for what arguments you can set that I've found so far is [this one over at GitHub](https://github.com/microsoft/security-devops-action/wiki#table-of-contents), but unfortunately this list isn't 100% complete. The reason for this is that GitHub doesn't include the credscan tool in its implementation of MSDO. I believe this is because the same, or similar, solutions are "default on" in [GitHub](https://docs.github.com/en/code-security/secret-scanning/about-secret-scanning), but this is just a guess. The result still is that as of right now we have no documentation for credscan settings.

Back to our task at hand. Using this document we can se that we need to turn of the pdb load error. A brief look in the list tells us there is a setting called `IgnorePdbLoadError`, so lets add the following to our .gdnconfig file and run again.

```json
{
  "tools": [
    {
      "tool": {
        "name": "BinSkim",
        "version": "Latest"
      },
      "arguments": {
        "IgnorePdbLoadError": "true",
        "Verbose": "true"
      }
    }
  ]
}
```

## The green green grass of home

Success! A pipeline is run, and run green!

![the output of our pipeline now that we fixed the pdb error](../images/azure.defenderfordevops/8.png)

You may also notice that this time we have a published artifact, and thus, if we go to our "Scans" tab, we can see even more results!

![the scans tab showing error results with details](../images/azure.defenderfordevops/9.png)

But wait...

- Green? we still have errors, right?
- And shouldn't we have more errors than this? What about all the other bad files in our repo?

Well, again, there's more we need to do to fix this.

There is a setting in the task simply called "break", with a default value of "false". This is the setting which tells MSDO if a failed test should actually break the pipeline, or just output the results and still show green. Adding this to our inputs gives us the following pipeline task.

```yaml
- task: MicrosoftSecurityDevOps@1
  displayName: 'Microsoft Security DevOps'
  inputs:
    config: 'gdnconfig/.gdnconfig'
    break: true
```

And the pipeline will now actually glow viciously red if an issue is detected.

![Stopped pipeline after setting break to true](../images/azure.defenderfordevops/10.png)

We still wont see the other errors though as this effectively stops the pipeline.

In order to move on we need to actually do something about our errors.

## Fixing binskim errors

I'm going to assume we can all agree that the best way to resolve an error is to fix the issue, but in some cases this isn't possible. We need some way to tell MSDO that "this error is ok. We can't or won't fix this" without turning all security of.

Unfortunately this is where the simplicity of this tool shines through. There is no obvious way to tell MSDO itself to include or exclude certain rules or files, but we have to go to the tools source directly.

No _obvious_ way that is. There is a file in the GitHub repo called [.gdnsuppress](https://github.com/microsoft/security-devops-action/blob/main/.gdn/.gdnsuppress) that _seems_ to be setting specific exclusions, however I have yet to dig in to and figure this file out.

And for our tool, binskim, [there seems to be no actual way to do this](https://github.com/microsoft/binskim/wiki/Can-I-exclude-files-from-a-scan%3F).
We will need to rebuild and fix our errors.

And since I am using an external tool and _can't_ fix these errors, we need to find another way of moving on..

## Running specific tools

Instead of fixing our binskim error, I'm opting for an easy exit: Let's not run binskim.

Back in our pipeline there are two ways of selecting what we actually want to run:

- Categories - Lets you set entire categories of tools to include, such as 'IaC', 'Secrets', and 'Containers'
- Tools - Lets you specify which tools to run instead.

> Note: All settings are comma separated. To set more than one category for example, you can do 'IaC,Secrets'

The good part of going with categories would be that any future tools included in this category will automatically be run in your pipeline. Less maintenance.

The downside is that there seems to be no documentation of which tools are included in which categories, and therefore we don't know what we are running.

The downside of both is that they are only one way, and there is currently no way of saying "run everything _but_ this (tool|category)"

Very well, For now let's enable all tools except binskim and see where this takes us.

```yaml
- task: MicrosoftSecurityDevOps@1
  displayName: 'Microsoft Security DevOps'
  inputs:
    config: 'gdnconfig/.gdnconfig'
    break: true
    tools: 'bandit,credscan,eslint,terrascan,templateanalyzer,trivy'
```

> Note: According to the Azure DevOps task help the correct name is 'template-analyzer', however this seems to be wrong if we look at the [tools list](https://github.com/microsoft/security-devops-action/wiki#TemplateAnalyzer-options).

Again, save and run our pipeline.

## Sverige, vi har ett resultat

![Result from a run without binskim](../images/azure.defenderfordevops/11.png)

But we're still getting a result from binskim in there, although zero results?

Since we still have the .gdnconfig file in our task setting and the .gdnconfig contains references to binskim this tool will in fact still run, however looking at the pipeline log we can see that it filters those results away.

```logfile
Results Query Summary:
  Tool Filters (Include): bandit, credscan, eslint, terrascan, templateanalyzer, trivy
```

Lesson learned: If you want to exclude a tool from your pipeline _completely_, remove it from your configuration as well.

But let's look at the rest of our data. A bit of really bad copy paste shows us that we indeed have results from more or less all of our files!

![ugly cropped copied and pasted results](../images/azure.defenderfordevops/12.png)

By now we have already looked at configs, and we know that in order to find how to approve these errors if we want them here we may need to go check the tool itself, so for now I'm just going to say I'm happy this stopped me from deploying unencrypted and publicly available storage accounts 🙂

There is however one more thing I'm going to dig in to...

## Secrets and not so secret secrets

Credscan. The tool that scans for secrets in Azure DevOps.

This tool is to me really interesting since this is, as far as I know, the first time it is publicly available outside of Microsoft, and also because I build and maintain a similar PowerShell module that does the same thing.

Searching for secrets is basically just a story of gathering, writing, and improving a million different regex patterns, and one of the thing that struck me when digging in to credscan specifically is that we do not know what kind of patterns it searches for.

In most cases this doesn't really matter, but in my case it makes me curious.

My testSecret.txt file contains of the following

```text
To find a secret you may for example have the text
Password = 'MyS0p@hS3cretPas5'

Or you may have something like to your SSH servers
ssh://EVILUSER:A1bcdEf@Abc12345.mysite.com:22

Or we are describing something in XML?
<Pwd>aTwzdW5pY29ybnMh</Pwd>
```

And it detects two patterns highlighted in this image

![image where the patterns matched is highlighted](../images/azure.defenderfordevops/13.png)

I have questions...

- Why doesn't it find the password string?
- why doesn't it match the last character of any of the two patterns, but _does_ match one character _before_ the actual passwords? (This might be the highlighter of course)

But ok, no patterns, no idea why. We'll come back to this again soon.

First let's try to tell credscan that these passwords are ok. It's just part of our documentation.

The way to "approve" a secret according to [the documentation](https://learn.microsoft.com/en-us/azure/defender-for-cloud/detect-exposed-secrets#suppress-a-same-line-secret) is to insert either this as a comment on the same line

```text
[SuppressMessage("Microsoft.Security", "CS001:SecretInLine", Justification="... .")]
```

Or this on the line _before_ the line containing the secret

```text
[SuppressMessage("Microsoft.Security", "CS002:SecretInNextLine", Justification="... .")]
```

Now already before I do this I see two issues here..

- This is an attribute class. I'm writing text. Classes don't exist in text, and neither does comments.
- Say I'm writing this as documentation (not to strange to do in text), would I want a blob of random data in there?

The obvious solution would be to exclude .txt files (or this specific file), but since we don't have no documentation on credscan like I said in the .gdnconfig chapter, there is no clear way of doing this. In fact, credscan will scan [a rather crazy amount of different file types!](https://learn.microsoft.com/en-us/azure/defender-for-cloud/detect-exposed-secrets#supported-file-types-and-exit-codes).

But let's try to add this attribute to our text file anyway.

```Text
To find a secret you may for example have the text
Password = 'MyS0p@hS3cretPas5' 

Or you may have something like to your SSH servers
[SuppressMessage("Microsoft.Security", "CS002:SecretInNextLine", Justification="This is documentation, not secrets")]
ssh://EVILUSER:A1bcdEf@Abc12345.mysite.com:22

Or we are describing something in XML?
<Pwd>aTwzdW5pY29ybnMh</Pwd> [SuppressMessage("Microsoft.Security", "CS001:SecretInLine", Justification="No secrets here either")]
```

And you guessed it, save and run..

And whadya know! It works!

![Log showing two secrets found, both suppressed](../images/azure.defenderfordevops/14.png)

I guess in order to have passwords in documentation we have to add a "remove suppression messages" step in our deployment pipeline.

> Note: For the sake of testing I also tried adding '//' and '#' before the extension attribute, and they all seem to work. Apparently anything is a comment in .txt files. Good to know.

## In conclusion - MSDO

MSDO is still in public beta, and as such it is expected to still be bugs, issues, and lacking documentation, and I'm ok with that. The lack of consistent documentation is an issue, but it's being worked on, and I'll also try to help when finding erroneous parts. The biggest issue I find is the inconsistency of it. Different things said depending on if you are at [the GitHub page for the Azure DevOps extension](https://github.com/microsoft/security-devops-azdevops), [the GitHub page for the GitHub extension](https://github.com/microsoft/security-devops-action), or [docs](https://learn.microsoft.com/en-us/azure/defender-for-cloud/defender-for-devops-introduction).

As for the product itself I find that whatever it might lack in advanced and detailed features it makes up for in multitudes by being incredibly easy to get started with. I dare say there is no competing product out there that is this easy to get up and running.

And all of this for the insane price of $0 (As of now. This may or may not change when this goes public.)

I truly do not see any reason _not_ to at least try this out.

That said: If you already have one or more other security tools in your pipeline toolbox, don't get rid of them yet. During my testing I found that it did miss both some bad configurations and some passwords, but still: Although other tools may find 1000 more bad configurations than MSDO, Finding one bad configuration is a thousand times better than finding zero.

## But... What about Defender for DevOps?! This is just MSDO!

This post has been really hard for me to write. I don't really know why, it just took days to get it done, where most my posts are done in hours.

And now I realize I have written one of the longest posts I've done, and haven't even reached the topic yet..

So instead of making this post unreadably long, I'm going to wrap it up like this:

__I promise, before new years I will create a part two where we connect MSDO to Defender for DevOps and start digging in there as well__

I hope that's ok for now.

## Post Scriptum

I must confess something. One of the first things I _really_ did was actually to download [the nuget package for the cli](https://www.nuget.org/packages/Microsoft.Security.DevOps.Cli) and also extract the actual running tools from one of my build hosts to see how it works, and while I did find many interesting things I wont mention, I will tell you one thing I find interesting.

I mentioned I choose to configure the "tools" flag to pick what tools I wanted to run, and one of the reasons I would prefer a "run everything _but_ this" setting is that they might include more tools in the future.

Well...
Try this instead, and have fun trying to get it all running 😉

```yaml
- task: MicrosoftSecurityDevOps@1
  displayName: 'Microsoft Security DevOps'
  inputs:
    tools: 'antimalware,bandit,binskim,credscan,eslint,gosec,roslynanalyzers,terrascan,templateanalyzer,trivy'
```
