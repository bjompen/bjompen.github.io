So.. another Monday shorty.
I promised a while ago to make a longer one soon,
and I will.. Big news ahead, but I am not ready to tell you yet.

Anyway, I keep finding that i always have to google or get-help on select-string,
so here´s my note to self:

<code>PS: > gci *.* -Recurse | Select-String -Pattern 'function' | select Path,LineNumber,Line</code>

<code>Path                                                  LineNumber Line</code>
<code>----                                                  ---------- ----</code>
<code>PS:\Function\functionTemplate.ps1          3 function $PLASTER_PARAM_FunctionName</code>
<code>PS:\Function\PlasterManifest.xml           5     <name>KTHPlasterFunction</name></code>
<code>PS:\Function\PlasterManifest.xml          15     <parameter name="FunctionName" type="text" prompt="Name of your Function" /></code>

Also <a href="https://msdn.microsoft.com/en-us/powershell/reference/5.1/microsoft.powershell.utility/select-string">Todays useful link!</a>

Now hopefully, this is enough to make me remember :)

//Bjompen