<#
.Synopsis
Exports environment variable from the .env file to the current process.

.Description
This function looks for .env file in the current directoty, if present
it loads the environment variable mentioned in the file to the current process.

.Example
 Set-PsEnv

.Example
 # This is function is called by convention in PowerShell
 # Auto exports the env variable at every prompt change
 function prompt {
     Set-PsEnv
 }
#>
function Set-PsEnv () {
    $localEnvFile = ".\.env"

    #return if no env file
    if (!( Test-Path $localEnvFile)) {return}

    #read the local env file
    $content = Get-Content $localEnvFile -ErrorAction Stop

    #load the content to environment
    foreach ($line in $content) {
        $kvp = $line -split "="
        [Environment]::SetEnvironmentVariable($kvp[0], $kvp[1], "Process") | Out-Null
        if ($env:DEBUGPSENV -eq "true") {
            [Environment]::GetEnvironmentVariable($kvp[0], "Process")
        }
    }
}