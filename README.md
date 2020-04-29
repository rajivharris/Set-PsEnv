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
Create a .env file at the folder level the environment variable has to be exported   
Sample .env file
```powershell
#This is a comment
#Prefix to a variable
PATH := c:\test
#Append to a variable
PATH =: c:\suffix\bin
#Assign a variable
PYTHON=c:\python
```
Installation
============

### From PowerShell Gallery
```powershell
Install-Module -Name Set-PsEnv
```