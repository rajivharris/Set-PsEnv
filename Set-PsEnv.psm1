$localEnvFile = ".\.env"
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
function Set-PsEnv {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param()

    #return if no env file
    if (!( Test-Path $localEnvFile)) {
        Write-Verbose "No .env file"
        return
    }

    #read the local env file
    $content = Get-Content $localEnvFile -ErrorAction Stop
    Write-Verbose "Parsed .env file"

    #load the content to environment
    foreach ($line in $content) {
        $kvp = $line -split "=",2
        if ($PSCmdlet.ShouldProcess("$($kvp[0])", "set value $($kvp[1])")) {
            [Environment]::SetEnvironmentVariable($kvp[0], $kvp[1], "Process") | Out-Null
        }
    }
}

Export-ModuleMember -Function @('Set-PsEnv')
