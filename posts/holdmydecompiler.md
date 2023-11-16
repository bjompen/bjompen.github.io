# Set-AzDoRepoPermission

There is a saying at [imgur](imgur.com): finished results first..
So if you're only curious in the result:

[**Here it is**](https://github.com/bjompen/Set-AzDoRepoPermission)

As quite recently stated, screamed, and blogged about, I'm doing two sessions at this years [PSConf](psconf.eu).

Since this is probably the biggest moment of my career so far, I dont wan't to be unprepared or stressed, so of course I already started writing material for them.

When reading through some related [Microsoft docs on setting up branching strategies](https://docs.microsoft.com/azure/devops/repos/git/require-branch-folders?view=azure-devops&tabs=command-line&wt.mc_id=DT-MVP-5005317) I stumbled upon something interesting...

`You will need the Team Foundation version control command (tf.exe).`

well... That ain't gonna fly, right? So I though...

![Hold my .net decompiler](../images/Set-AzDoPermission/holdmydecmpiler.png)

## Fire up ye old jetbrains

Jetbrains dotPeek is an excelent little tool to start with. You can use it to load any .dll, .exe, or other .net based program, and it will decompile it and show you whats going on.

So I did.

I would absolutely lie if I said I found the truth there though, but some hints about how the git commands, and in particular "tf git permission.." behaves.

## F12 to the rescue

Next step of data gathering was fireing up the browser, clicking through the GUI, all while checking the network log to see what was sent.

Given [I have an entire blogpost on this](posts/f12.md) I wont go in to more details, but the body and security details in the decompile was starting to make sense..

When we set git permissions in the GUI we post a body to the [AccessControllEntries](https://docs.microsoft.com/rest/api/azure/devops/security/access-control-entries/set-access-control-entries?view=azure-devops-rest-7.1&wt.mc_id=DT-MVP-5005317) API. This *API is fairly good documented, so how come I "have to use tf.exe"? Well, one thing that _isn't_ documented anywhere is how to set access controll on a branch that doesn't yet exist in Azure DevOps..

## Looking at the data gathered

I have the following:

```Powershell
{
  "token": "repoV2/loads/of/numbers",
  "merge": true,
  "accessControlEntries": [
    {
      "descriptor": "Microsoft.TeamFoundation.Identity;<SID>",
      "allow": <int values>,
      "deny": <int values>,
      "extendedinfo": {
          <honestly I can't remember what was in here.. I shouldn't have removed it _before_ blogging...>
    }
  ]
}
```

looks nice, but just about nothing in here was properly documented.

## Bashing through the GUI some more

I captured trafic on different repos, different projects, and different accesses and after loads of documenting i ended with this list instead.

```Powershell
{
  "token": "repoV2/OrginizationID/ProjectID/refs/heads/<numbers>",
  "merge": true,
  "accessControlEntries": [
    {
      "descriptor": "<An Azure DevOps Group SID>",
      "allow": int value of a binary ENUM of accesses,
      "deny":  same as allow, int value of a binary ENUM of accesses,
      "extendedinfo": {
          and the reasonb i removed this: it wasn't needed..
    }
  ]
}
```

Still two things to figure out though:

- I realize the `<numbers>` must be some reference to my branch, but since the branch doesn't exist yet it must be a name reference
- I have never encountered a SID on a Azure DevOps user group, so what is this?

## Google - Even the pros do it

I found [This bloggpost by Jesse Houwing](https://jessehouwing.net/azure-devops-git-setting-default-repository-permissions/) who appears to have done the same journey as me, but in a different language.

He gave an excelent example and description, along with some powershell code, to calculate paths. The numnbers are the branch name converted to a hexadecimal string!

Thank you Jesse - One to go.

## Back to the API documentation

Azure DevOps API documentation is.. flexible. Some things are great documented, some things, not so much.

Some things are refered to as "legacy", without there beeing replacements for them, Some things can't be found in the replacement APIs, and some things are.. well.. not documented at all.

PUID (or is it just UID?), it turns out, is legacy.

I found [this API](https://docs.microsoft.com/rest/api/azure/devops/ims/identities/read-identities?view=azure-devops-rest-7.1&wt.mc_id=DT-MVP-5005317) that documents how to get the UID, but I have to search using data from another API, and only some types of queries include what I need.

But at least we have all we need.

## A little bit of coding and a little bit of whiskey later

I have it up on GitHub using the above posted link.
Might upload it to gallery, but thats for later.

And all of this because of the sentence:

**You will need the Team Foundation version control command (tf.exe).**
