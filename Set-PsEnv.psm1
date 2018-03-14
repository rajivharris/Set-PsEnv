#Load .env file from the current directory
#Add support for common definition files
#Add support for variable expansion
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