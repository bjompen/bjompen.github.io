Well.. as expected, my plan for once a week went south.
But I finally had something to write about, so here goes.

I was recently tasked with writing a integration for SalesForce at work
Just as any normal task I started with google, what had people done before and was it already solved.
Turns out SalesForce, atlhough it has a really well documented API, does not seem to have a powershell module.

Well, read on to see how awesome it turned out.

First of, i needed a test Salesforce account and settings. Fairly easy, and summarized here:

<strong>Data Creation and gathering</strong>
<ul>
 	<li>Create developer account, they are free from here: <a href="https://developer.salesforce.com/signup">Salesforce developer account</a></li>
 	<li>Log in to account webpage
Note the first letters in the url, https://eu12.lightning.force.com/ eu12 in my case. You'll need those later.</li>
 	<li>Go to Apps -&gt; App Manager and create a new connected app.
Note the Consumer key and the consumer secret
<ul>
 	<li>If you missed them, they can be found in Apps -&gt; connected apps -&gt; manage connected apps</li>
</ul>
</li>
 	<li>Click the small button besides your created app and select 'View'
Go to Apps -&gt; Connected Apps -&gt; Manage Connected app -&gt; Click to select your newly created app
<ul>
 	<li>Check settings for oauth policies. If they are wrong, click edit policies and change
<a href="http://www.bjompen.com/wp-content/uploads/2018/04/accountSettings.png"><img class="alignnone size-medium wp-image-97" src="http://www.bjompen.com/wp-content/uploads/2018/04/accountSettings-300x84.png" alt="" width="300" height="84" /></a></li>
</ul>
</li>
 	<li>Click your user avatar -&gt; settings to go to user settings</li>
 	<li>Select 'Reset my security token' to receive user token</li>
</ul>
You should now have the following infomation:
<ul>
 	<li>Username (my.user@domain.com)</li>
 	<li>Password (password)</li>
 	<li>Consumer Secret (1234567890123456789)</li>
 	<li>Consumer Key (ReallyLongStringFullOfNumbersLike1234567890AndEvenSomeCharacterrsLike_./ThrownInThere)</li>
 	<li>User Token (25RandomCharactersNumbers)</li>
 	<li>Domain for connection (eu01)</li>
</ul>
<strong>Powershell stuff</strong>
Connecting to Salesforce using Oauth password
For all of SalesForce API requests, we need to make sure we use TLS 1.2, but this is not default in Powershell.
To set the security protocol to TLS1.2
<pre class="psconsole">&gt; [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
</pre>
In order to send requests to your SalesForce API you first need to get an access token.
You get this by creating a custom webrequest to the oauth endpoint.
Create a body that looks like this:
<pre class="psconsole">$authBody = @{
  grant_type = 'password' # This is a string, not your password, to tell the API we want to use Password authentication.
  client_id = $SalesForceClientID # This is your consumer key previously fetched
  client_secret = $SalesForceClientSecret # This is your consumer secret
  username = $SalesForceUsername # Your username
  password = $PassToken # This is a combination of your password and your token. See below.
}
</pre>
$PassToken is your password and your user token combined in to one string without spaces. In my example above:
<pre class="psconsole">&gt; $Password = 'password'
&gt; $UserToken = '25RandomCharactersNumbers'
</pre>
PassToken would then be 'password25RandomCharactersNumbers'
<pre class="psconsole">&gt; $PassToken = "$SalesForceServicePassword$SalesForceToken"
</pre>
Now, remember those first letters in your url at the top? eu12?
You need those to know which host you should talk to.
To receive your token, send a POST request with your body to the URI
<pre class="psconsole">&gt; https://&lt;yourdomain&gt;.salesforce.com/services/oauth2/token</pre>
In my case, it would be
<pre class="psconsole">&gt; https://eu12.salesforce.com/services/oauth2/token</pre>
If you are successfull, you should now get back something like this:
<pre class="psconsole">&gt; access_token :
&gt; instance_url :
&gt; id :
&gt; token_type : 'Bearer' # This is not user specific. For Oauth it is always bearer.
&gt; issued_at :
&gt; signature :
</pre>
It is good to keep this one in a variable, since we need it for all requests in this session.
<pre class="psconsole">&gt; $AccessToken = Invoke-RestMethod -Uri 'https://eu12.salesforce.com/services/oauth2/token' -Method POST -Body $authBody</pre>
Now on to the good stuff.

Sending requests to the SalesForce API
We will start of with something somewhat simple right?
Searching for a user!

SalesForce API is actually quite a mess of different endpoints, and not always easy to navigate.
Fortunately, there is a API browser available online, at <a href="https://workbench.developerforce.com/">https://workbench.developerforce.com/</a>
Log in there using your SalesForce account, and select 'Utilities' -&gt; 'Rest Explorer' to get to the API browser.
Executing the default 'Get' will give us a long list of objects to browse,
One of them is 'Search'.
Clicking that will however only show an error, as we need to input a query of some kind.

Instead of telling you how i know, lets just say i do know that SalesForce uses something called SOQL, Salesforce Object Query Language.
<a href="https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_soql.htm"> Read all about that here.</a>
Using this link, and <a href="https://developer.salesforce.com/docs/atlas.en-us.soql_sosl.meta/soql_sosl/sforce_api_calls_sosl_find.htm">also this</a>
We can now start to construct our query. (Yes, in my case that actually included reading loads of more pages. If you are serious about learning SOQL, you should do it to.)
In the end i get something like this:
FIND+{&lt;search&gt;}+IN+&lt;property&gt;+FIELDS+RETURNING+USER(&lt;userproperties&gt;)
Userproperties? Well, back to the workbench explorer.
Users, and a lot of other things, in Salesforce are called SObjects.
Entering the SObjects API we find a User, and under that a Describe. Describing users sounds good.
This endpoint contains a fields 'folder' showing the available properties,
And using this information we can now nomplete the query:
<pre class="psconsole">FIND+{björn}+IN+name+FIELDS+RETURNING+USER(id,name,username)</pre>
So using the error from the /search url, we can construct a full query URL
<pre class="psconsole">/services/data/v41.0/search/?q=FIND+{björn}+IN+name+FIELDS+RETURNING+USER(id,name,username)</pre>
Paste it into the Workbench field and execute. Success!
But we are not here to browse stuff.

Using the $accessToken we have, we can create a complete search request.
<pre class="psconsole">&gt; $Method = 'Get' # What was set in the workbench
&gt; $URI = "$($AccessToken.instance_url)/services/data/v41.0/search/?q=FIND+{björn}+IN+name+FIELDS+RETURNING+USER(id,name,username)" # The URL from your token plus the relative path from workbench
&gt; $Headers = @{
  'Authorization' = "Bearer $($AccessToken.access_token)"
  'Accept' = 'application/json'
} # See description below
</pre>
We must alwas set the header in our requests, as that is how we show that we have the correct token.
Using Oauth username password it is always set as the string 'Bearer access_token'
Also, we always want json offcourse ;)

So lets try it:
<pre class="psconsole">&gt; Invoke-RestMethod -URI $URI -Method $Method -Headers $Headers
</pre>
Success!

And you can now go ahead and start messing about in the SalesForce API.

But I started by saying it turned out awesome.
Just searching using powershell and variables isn't that nice,
So I wrapped this, and a few more api calls in a module,
Alongside a 'Invoke-APSalesForceRestMethod' that automaticatly wraps the token and creates a valid request from it.

Then we managed to convince our employer to open source it.

So without further delay,
you can download / fork / clone our SalesForce module here:
<a href="https://github.com/SnowSoftware/AutomationPlatform-SalesForce.Integration">https://github.com/SnowSoftware/AutomationPlatform-SalesForce.Integration</a>
And please help out, send bug reports, add functionality and use it!

And this is the awesome part.
We managed to get our company, <a href="https://www.snowsoftware.com">Snow Software</a>, to open source our software.
and there is more to come, so stay tuned!

&nbsp;

Oh, and I still need to learn how to format things on my blog..

&nbsp;

'Til nex time, whenever that may be!