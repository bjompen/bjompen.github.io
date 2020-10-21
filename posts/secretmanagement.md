# Shh... Let me tell you a secret

## I think it's time to talk some PowerShell again

I haven't done so in quite some time.

That doesn't mean I haven't written any code, I just haven't really worked on anything worth blogging about in a while.

One of our ancient problems in the PowerShell world is this question:

**How do I store credentials in my code, without storing credentials in my code?**

Well, sure, we've had [CliXML](https://powershellcookbook.com/recipe/PukO/securely-store-credentials-on-disk) for some time now,

And sure, we can use [SecureString](https://docs.microsoft.com/powershell/module/microsoft.powershell.security/convertto-securestring),

But there has never been one standardized, cross platform, way of doing so.

Enter **Secret Management**

## So what is Secret Management?

Well, The short answer is best taken from the [Secret Management GitHub page](https://github.com/PowerShell/SecretManagement)

> PowerShell SecretManagement module provides a convenient way for a user to store and retrieve secrets.

To put it in my own words:

> Secret management provides me with one way to interact with my secrets, no matter where those secrets are stored. If you learn to manage your secrets in for example Azure, you use the same way to manage them in your keepass database, your local credential store, or anywhere else there is a vault

### The design of secret management

One thing worth noting right away before we start exploring stuff is that the secret management module is designed slightly different than what we might be used to.
In order to start using it we first need to install the *SecretManagement* module.

This is the module containing our "get" and "set" commands, but this module in itself contains no way of storing the secrets.

The storage in turn is handled by using *vaults*, And these modules are different depending on where you want to store your secrets. Hopefully there will be a blogpost in the future going more in to details about vaults, but for now, lets just look at the existing stuff.

## Enough with the rambling, lets dive in to it

### Let's start by installing the modules we need

Since this module is still in beta we need to use the Prerelease switch, and this in turn requires full name of module. And while at it, let's also include the demo/default secret store from the team.

```PowerShell
Find-Module Microsoft.PowerShell.SecretManagement -AllowPrerelease | Install-Module -Scope CurrentUser
Find-Module Microsoft.PowerShell.SecretStore -AllowPrerelease | Install-Module -Scope CurrentUser
```

For this post, and because this is what I normally use, let's also see if we can install vaults for Azure and KeePass.

```PowerShell
PS> Find-Module -Tag SecretManagement

Version              Name                                Repository           Description
-------              ----                                ----------           -----------
0.1.0                SecretManagement.LastPass           PSGallery            SecretManagement extension for LastPass!
0.1.1                SecretManagement.KeyChain           PSGallery            SecretManagement extension vault for macOS…
0.0.4.4              SecretManagement.KeePass            PSGallery            A cross-platform Keepass Secret Management…
```

Ok, KeePass is there, but no Azure Keyvault, and since we can't use wildcard or tags to search in prereleases, I can't find it!

Well, It turns out there is a vault module for azure in the [Secret Management pages at GitHub](https://github.com/PowerShell/SecretManagement/tree/master/ExtensionModules/AKVaultScript), but I can't seem to find it released in the gallery, so let's instead clone the repo and go from there.

### As for KeePass

It turns out running prerelease stuff in combination with the split module thing has a somewhat unexpected problem.

If you put a required module in your module manifest, and that module is only in prerelease, it fails to install, or even save.

[I added this to a discussion in the GitHub repo](https://github.com/JustinGrote/SecretManagement.KeePass/issues/3), but as of this writing I have still not managed to get it installed the PowerShell way.

![installation fail...](..\images\PSSecret\uninstallable.png)

I decided that for now I'll skip this one and come back to it later.

So, onwards to test what we have, and what we found.

### Setting up your vaults

The first thing you need to do is register your vaults.
This is done using the `Register-SecretVault` CmdLet, so like always in PowerShell, let's read the help.

```PowerShell
Get-Help Register-SecretVault
```

The syntax is fairly simple, we have

- A name. This is what you will call the vault.
- A modulename of the vault (the one we installed)
- a DefaultVault switch
- and VaultParameters. A HashTable of stuff we'll come back to later.

So lets register the default vault first

```PowerShell
Register-SecretVault -Name SecretStore -ModuleName Microsoft.PowerShell.SecretStore
```

Here's what I think is the first sign of this still being in early beta: *There is absolutely no feedback at all. Success? Failure? who knows.*

Anyway, lets test the vault to see if we can store secrets in it.

There is a CmdLet called `Test-SecretVault`, that 

> runs an extension vault self test (...) return 'True' if all tests succeeded, and 'False' otherwise.

Unfortunately, there is no documentation in the help file that says what tests are performed, so instead, we'll just jump right in and try to add something.

### Adding and reading secrets

```PowerShell
Set-Secret -Name 'MyTestSecret' -Secret 'SuperSecretString'
```

The first thing noticed is that even though the vault registration worked, We still need to supply a password for the creation of our vault storage.

The first time we access this vault we will need to unlock it using this key, and by running the `Get-SecretStoreConfiguration` CmdLet from the *Microsoft.PowerShell.SecretStore* module we can see that it remains unlocked for a default of 900 seconds. 

This also shows what could be perceived as a the problem with split modules: *Command discoverability*. I usually use `Get-Command -Module '<ModuleName>'` to explore, but because of the split modules that behaviour is harder.

Getting a secret from this works pretty straight forward and as expected.

The default behaviour is always to return a SecureString, but using the AsPlainText switch we get our secret in clear text. This is a great way of treating secrets, as it makes it easy to use both when creating credential objects, and also when just needing things in the console.

```PowerShell
PS> Get-Secret -Name 'MyTestSecret'
System.Security.SecureString
PS> Get-Secret -Name 'MyTestSecret' -AsPlainText
SuperSecretString
```

Of course there are also CmdLets for listing all secrets available. Good thing, otherwise I would need a SecretNameManager as well.

```PowerShell
PS> Get-SecretInfo

Name            Type VaultName
----            ---- ---------
MyTestSecret  String SecretStore
MyTestSecret2 String SecretStore
MyTestSecret3 String SecretStore
```

So far, so good. I think we got the baseline down, so lets add another vault.

### Using multiple vaults

Registering another vault should technically be just as easy as registering the first one, but for Azure we have a couple of things we need to note:

- Because I can't find it in the gallery, I forked the [Secret Management repo at GitHub](https://github.com/PowerShell/SecretManagement), and cloned it to my computer so I have the Azure KeyVault module available. When registering the vault I used the full path, but of course you could also place it in your `$env:PSModulePath`

- Azure requires some more information when registering the vault:
  - Azure Subscription ID
  - a keyvault name

Now here's the kicker: there is absolutely nothing that tells you this. Not even the error messages.
In fact, the error message we get if we don't supply it is

> To use  Azure vault, the current user must be logged into Azure account subscription . Run 'Connect-AzAccount -SubscriptionId '.

Coincidently the same error message you get if you forget to log in to Azure.

I had to read the source for the module to understand this, and figure out what keys the vault parameters needed.

Like previously mentioned, `Register-SecretVault` has a VaultParameters parameter. This is what we use to supply a hashtable with settings for our vault.

```PowerShell
$AzParams = @{
  'SubscriptionId' = '00000000-1111-2222-3333-444444444444'
'AZKVaultName' = 'MySecretManagementKV'
}
$MyModulePath = (Get-Item $MyGitClonedRepo\ExtensionModules\AKVaultScript).pspath
Register-SecretVault -Name 'AKVault' -ModuleName $MyModulePath -VaultParameters $AzParams
```

After we have registered this, just as the afore mentioned error message said, we need to run the `Connect-AzAccount` CmdLet to log in to azure, And we're good to go using our fancy Azure vault as well.

So far Azure only supports the usage of SecureStrings for secrets though, and just like in other places, the error messages leaves a bit to wish for, but as log as you use the `SecureStringSecret` parameter for `Set-Secret` you're good to go.

```PowerShell
PS> $MyTopSecretMessage = ConvertTo-SecureString -String 'SuperSecretAzureMessage' -AsPlainText
PS> Set-Secret -SecureStringSecret $MyTopSecretMessage -Name 'MyAzureSecret' -Vault 'AKVault'
PS> Get-Secret -Name 'MyAzureSecret' -AsPlainText
SuperSecretAzureMessage
```

BOOM!

## More stuff to think about

So I have two out of my three wishes done and figured out.

Worth noting is that we will always have a Default vault, and it is possible to have the same secret name in multiple vaults, so:

*All commands run without the parameter '-Vault' set will be placed or read in your default Vault*

```PowerShell
PS> Get-SecretInfo

Name                  Type VaultName
----                  ---- ---------
MyAzureSecret SecureString SecretStore
MyAzureSecret SecureString AKVault

PS> Get-Secret -Name 'MyAzureSecret' -AsPlainText
SuperSecretLocalMessage
PS> Get-Secret -Name 'MyAzureSecret' -Vault 'AKVault' -AsPlainText
SuperSecretAzureMessage
```

## But did we actually solve the secrets problem

Well, yes and no.

It is great that we can use this to store our secrets and manage them in a secure and standardized way, but in order to get secrets from Azure I still need to login, which requires a password/token/some login secret. There's a catch 22 in secret management where we just tend to move the problem one step away.

So far my simplest and dirtiest solution to this is

- Create a local vault with no password for my service or automation user.
  - Since this uses your personal certificate for encryption, no other user can decrypt my secrets. It's not safe, but less not safe.
- From my local vault, get my API/Application Keys to connect to Azure keyvault.

If you have a better solution, please let me know.

## Final words

I am fully aware of how early this product still is, and with that, flaws are expected. I'm hoping you, the reader, head first in to other problems that you can tell me about next time.

I may come of as negative here complaining about error messages, but that is absolutely not my point. This initiative, and the work done so far, is amazing.

Finally, some shout outs to the involved people. You are all amazing!

[Paul Higinbotham](https://twitter.com/pshdev)

[Steve Lee](https://twitter.com/Steve_MSFT)

[Sydney Smith](https://twitter.com/sydneysmithreal)

[Justin Grote](https://twitter.com/JustinWGrote)
