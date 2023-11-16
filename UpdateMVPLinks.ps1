$MVPId = '?wt.mc_id=DT-MVP-5005317'
$sites = @(
    'https://social.technet.microsoft.com/',
    'https://docs.microsoft.com/',
    'https://azure.microsoft.com/',
    'https://techcommunity.microsoft.com/',
    'https://social.msdn.microsoft.com/',
    'https://devblogs.microsoft.com/',
    'https://developer.microsoft.com/',
    'https://channel9.msdn.com/',
    'https://gallery.technet.microsoft.com/',
    'https://cloudblogs.microsoft.com/',
    'https://technet.microsoft.com/',
    'https://docs.azure.cn/',
    'https://www.azure.cn/',
    'https://msdn.microsoft.com/',
    'https://blogs.msdn.microsoft.com/',
    'https://blogs.technet.microsoft.com/',
    'https://microsoft.com/handsonlabs/',
    'https://csc.docs.microsoft.com/',
    'https://learn.microsoft.com/'
)

$AllPosts = Get-ChildItem .\posts\*.md

$pattern = '(?<=]\()[^)]*'

foreach ($site in $sites) {
    $hits = $AllPosts | Select-String -Pattern $site -AllMatches
    foreach ($hit in $hits) {
        if ($hit.Line -notlike "*$MVPId*") {
            $originalLine = $hit.Line
            $patMatches = [regex]::matches($hit.Line, $pattern).Value
            foreach ($patMatch in $patMatches) {
                [URI]$replaceUrl = $patMatch
                if ($replaceUrl.OriginalString -like "$site*") {
                    if (-not [string]::IsNullOrWhiteSpace($replaceUrl.Query)) {
                        $newQuery = "$($replaceUrl.Query)$($MVPId.Replace('?','&'))"
                    }
                    else {
                        $newQuery = $MVPId
                    }
                    $newUrl = "$($replaceUrl.Scheme)://$($replaceUrl.Host)$($replaceUrl.AbsolutePath.Replace('en-us/','').Replace('en-gb/','').TrimEnd('/'))$newQuery$($replaceUrl.Fragment)"
                    $newLine = $originalLine.Replace($replaceUrl.OriginalString, $newUrl)

                    (Get-Content $hit.Path -Raw).replace($originalLine, $newLine) | Set-Content $hit.Path -NoNewline
                }
            }
        }
    }
}
