function Build-Rss {
    param (

    )
    
    $Header = @"
<?xml version="1.0" encoding="UTF-8" ?>
<rss version="2.0">

`t<channel>
`t`t<title>Bjompen - A blog about things and stuff...</title>
`t`t<link>https://www.bjompen.com</link>
`t`t<description>I write text. Mostly PowerShell, but also stuff.</description>`n
"@

    $Footer = @"

`t</channel>

</rss>
"@

    $SideBar = Get-Content $PSScriptRoot\..\_sidebar.md | Where-Object {$_ -match '-\s+\[[a-zA-Z0-9\w].*\](.*)$'}

    $Res = $Header
    $Res += $SideBar | ForEach-Object {
        $Null = $_ -match '\[(?<Title>.*)]\((?<Link>.+\.md)\s+"(?<description>[^"]*)'
        $Title = $Matches.Title
        $Link = $Matches.Link
        $Description = $Matches.Description
"`n`t`t<item>
`t`t`t<title>$Title</title>
`t`t`t<link>https://www.bjompen.com/$Link</link>
`t`t`t<description>$Description</description>
`t`t</item>"
    }
    $Res += $Footer
    $Res | Out-File $PSScriptRoot\rss.xml -Force 
}

Build-Rss