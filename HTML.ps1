class HTML {
    [string]$Title = "HTML Report"
    [string]$Style = @"
        body { font-family: Arial; background-color: #1e1e1e; color: #d4d4d4; padding: 20px; }
        h1, h2 { color: #00ff00; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #555; padding: 8px; text-align: left; }
        th { background-color: #2e2e2e; color: #00ff00; }
        tr:nth-child(even) { background-color: #2a2a2a; }
"@
 
    [System.Collections.Generic.List[string]]$BodySections = @()
 
    HTML([string]$title) {
        if ($title) { $this.Title = $title }
    }
 
    [void]AddTitle([string]$text, [int]$level = 1) {
        $safeLevel = if ($level -gt 6 -or $level -lt 1) { 1 } else { $level }
        $this.BodySections.Add("<h$($safeLevel)>$text</h$($safeLevel)>")
    }
 
    [void]AddStyle([string]$cssBlock) {
        $this.Style += "`n$cssBlock"
    }
 
    [void]AddTableFromObject([object[]]$InputObject, [string[]]$Properties) {
        if (-not $InputObject) {
            $this.BodySections.Add("<p><i>No data available for table.</i></p>")
            return
        }
 
        $table = "<table><thead><tr>"
        foreach ($prop in $Properties) {
            $table += "<th>$prop</th>"
        }
        $table += "</tr></thead><tbody>"
 
        foreach ($item in $InputObject) {
            $table += "<tr>"
            foreach ($prop in $Properties) {
                $value = ($item | Select-Object -ExpandProperty $prop -ErrorAction SilentlyContinue)
                $table += "<td>$value</td>"
            }
            $table += "</tr>"
        }
 
        $table += "</tbody></table>"
        $this.BodySections.Add($table)
    }
 
    [string]BuildHtml() {
        return @"
<!DOCTYPE html>
<html>
<head>
<title>$($this.Title)</title>
<style>
    $($this.Style)
</style>
</head>
<body>
    $($this.BodySections -join "`n")
</body>
</html>
"@
    }
}