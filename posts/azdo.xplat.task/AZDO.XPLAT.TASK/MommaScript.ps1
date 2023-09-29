Param(
    [string]$Icons
)

ipmo $PSScriptRoot\BasicFunction\

if (-not [string]::IsNullOrEmpty($Icons)) {
    Invoke-FruitAPI -Icons
}
else {
    Invoke-FruitAPI
}

Remove-Module BasicFunction
