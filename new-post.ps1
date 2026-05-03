param(
    [Parameter(Mandatory=$true)]
    [string]$Title
)

$date   = Get-Date -Format "yyyy-MM-dd"
$slug   = $Title -replace '\s+', '-'
$folder = "content\post\$date-$slug"
$index  = "$folder\index.md"

New-Item -ItemType Directory -Path $folder -Force | Out-Null

@"
+++
title = "$Title"
date = $date
draft = false
tags = []
categories = []
+++

"@ | Set-Content -Path $index -Encoding utf8

Write-Host ""
Write-Host "Post created: $folder"
Write-Host ""
Write-Host "Workflow:"
Write-Host "  1. Open $index and write your content"
Write-Host "  2. Drop images into the same folder: $folder\"
Write-Host "  3. Reference them with:  ![alt text](your-image.png)"
Write-Host ""
