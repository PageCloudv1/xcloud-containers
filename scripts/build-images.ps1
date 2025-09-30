[CmdletBinding()]
param(
    [string]$Tag = "latest",
    [switch]$SkipRetag
)

$ErrorActionPreference = "Stop"

function Write-Step($Message) {
    Write-Host "`n=== $Message ===" -ForegroundColor Cyan
}

$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location $repoRoot

try {
    Write-Step "Building xcloud-base:$Tag"
    podman build `
        --file "base/Podmanfile" `
        --tag "localhost/xcloud-base:$Tag" `
        "base"

    if (-not $SkipRetag) {
        Write-Step "Tagging base image for ghcr.io"
        podman tag "localhost/xcloud-base:$Tag" "ghcr.io/pagecloudv1/xcloud-base:$Tag"
    }

    Write-Step "Building xcloud-nodejs:$Tag"
    podman build `
        --file "nodejs/Podmanfile" `
        --tag "localhost/xcloud-nodejs:$Tag" `
        "nodejs"

    if (-not $SkipRetag) {
        Write-Step "Tagging Node.js image for ghcr.io"
        podman tag "localhost/xcloud-nodejs:$Tag" "ghcr.io/pagecloudv1/xcloud-nodejs:$Tag"
    }

    Write-Step "Building xcloud-python:$Tag"
    podman build `
        --file "python/Podmanfile" `
        --tag "localhost/xcloud-python:$Tag" `
        "python"

    if (-not $SkipRetag) {
        Write-Step "Tagging Python image for ghcr.io"
        podman tag "localhost/xcloud-python:$Tag" "ghcr.io/pagecloudv1/xcloud-python:$Tag"
    }

    Write-Host "`nTodas as imagens foram construídas com sucesso." -ForegroundColor Green
}
finally {
    Pop-Location
}
