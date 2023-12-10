$MVPId = '?wt.mc_id=DT-MVP-5005317'

# List of sites to update links for
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

# Get all posts
$AllPosts = Get-ChildItem .\posts\*.md

# Regex pattern to find links in markdown files
$pattern = '(?<=]\()[^)]*'

foreach ($site in $sites) {
    $hits = $AllPosts | Select-String -Pattern $site -AllMatches
    foreach ($hit in $hits) {
        # Skip if the line already contains the MVPId
        if ($hit.Line -notlike "*$MVPId*") {
            $originalLine = $hit.Line
            $newLine = $originalLine
            $patMatches = [regex]::matches($hit.Line, $pattern).Value
            foreach ($patMatch in $patMatches) {
                [URI]$replaceUrl = $patMatch
                if ($replaceUrl.OriginalString -like "$site*") {
                    if (-not [string]::IsNullOrWhiteSpace($replaceUrl.Query)) {
                        # If the url already contains a query string, append the MVPId
                        $newQuery = "$($replaceUrl.Query)$($MVPId.Replace('?','&'))"
                    }
                    else {
                        $newQuery = $MVPId
                    }
                    # Build the new url and remove the language part
                    $newUrl = "$($replaceUrl.Scheme)://$($replaceUrl.Host)$($replaceUrl.AbsolutePath.Replace('en-us/','').Replace('en-gb/','').TrimEnd('/'))$newQuery$($replaceUrl.Fragment)"
                    # Keep track of the changes until we have all the changes in case there are multiple links in the same line
                    $newLine = $newLine.Replace($replaceUrl.OriginalString, $newUrl)
                }
            }

            # Replace the line in the file
            if ($newLine -ne $originalLine) {
                (Get-Content $hit.Path -Raw).replace($originalLine, $newLine) | Set-Content $hit.Path -NoNewline
            }
        }
    }
}
