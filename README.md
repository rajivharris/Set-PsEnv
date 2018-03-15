# Set-PsEnv

PowerShell DotEnv

This is a simple script to load the .env file to process environment from the current directory.

Usage
==========
Add the function Set-PsEnv to the prompt function.

```powershell
Set-PsEnv
```

```powershell
# This is function is called by convention in PowerShell
function prompt {
    Set-PsEnv
}
```
Installation
============

### From PowerShell Gallery
```powershell
Install-Module -Name Set-PsEnv
```