Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

Write-Host (Get-Location).Path

$nuGetApiKey = $env:PSGALLERY_TOKEN

try{
    Publish-Module -Name Set-PsEnv -NuGetApiKey $nuGetApiKey -ErrorAction Stop -Force #-Debug
    Write-Host "Set-PsEnv has been Published to the PowerShell Gallery!"
}
catch {
    throw $_
}
