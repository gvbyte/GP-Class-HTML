.  "$PSScriptRoot\HTML.ps1"
function New-HTML([string]$Title){return [HTML]::new("$($Title)")}