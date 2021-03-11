$localEnvFiles = ".env", ".envrc"
<#
.Synopsis
Exports environment variable from the .env file to the current process.

.Description
This function looks for .env file in the current directoty, if present
it loads the environment variable mentioned in the file to the current process.

.Example
 Set-PsEnv
 
 .Example
 #.env file format
 #To Assign value, use "=" operator
 <variable name>=<value>
 #To Prefix value to an existing env variable, use ":=" operator
 <variable name>:=<value>
 #To Suffix value to an existing env variable, use "=:" operator
 <variable name>=:<value>
 #To comment a line, use "#" at the start of the line
 #This is a comment, it will be skipped when parsing

.Example
 # This is function is called by convention in PowerShell
 # Auto exports the env variable at every prompt change
 function prompt {
     Set-PsEnv
 }
#>
function Set-PsEnv {
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = 'Low')]
    param(
         [switch] $reload
    )
    $scriptName = $MyInvocation.MyCommand

    if(!$reload) {
        if($Global:PreviousDir -eq (Get-Location).Path){
            Write-Verbose "Skipping same dir"
            return
        } else {
            $Global:PreviousDir = (Get-Location).Path
        }
    }

    $localEnvFile = $localEnvFiles.Where({ Test-Path $_ })
    #return if no env file
    if (!$localEnvFile) {
        if($reload) {
            Write-Output "${scriptName}: No $localEnvFile file, exiting."
        } else {
            Write-Verbose "No $localEnvFile file, exiting."
        }
        return
    }

    #read the local env file
    $content = Get-Content $localEnvFile -ErrorAction Stop
    Write-Verbose "${scriptName}: Loading $localEnvFile ..."

    $keys = @()
    #load the content to environment
    foreach ($line in $content) {

        if([string]::IsNullOrWhiteSpace($line)){
            Write-Verbose "Skipping empty line"
            continue
        }

        #ignore comments
        if($line.StartsWith("#")){
            Write-Verbose "Skipping comment: $line"
            continue
        }

        #get the operator
        if($line -like "*:=*"){
            Write-Verbose "Prefix"
            $kvp = $line -split ":=",2
            $key = $kvp[0].Trim()
            $value = "{0};{1}" -f  $kvp[1].Trim(),[System.Environment]::GetEnvironmentVariable($key)
        }
        elseif ($line -like "*=:*"){
            Write-Verbose "Suffix"
            $kvp = $line -split "=:",2
            $key = $kvp[0].Trim()
            $value = "{1};{0}" -f  $kvp[1].Trim(),[System.Environment]::GetEnvironmentVariable($key)
        }
        else {
            Write-Verbose "Assign"
            $kvp = $line -split "=",2
            $key = $kvp[0].Trim()
            $value = $kvp[1].Trim()
        }

        $key = $key.replace('export ', '').Trim()

        Write-Verbose "$key=$value"
        $keys += $key

        if ($PSCmdlet.ShouldProcess("environment variable $key", "set value $value")) {            
            [Environment]::SetEnvironmentVariable($key, $value, "Process") | Out-Null
        }
    }

    Write-Output "${scriptName}: Set $localEnvFile Env variables: $keys"
}

Export-ModuleMember -Function @('Set-PsEnv')
