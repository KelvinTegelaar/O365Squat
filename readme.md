# PowerShell Typosquat

A PowerShell based typosquatting tool based on the work of O365Squad here: https://github.com/O365Squad/O365-Squatting.

## How it works

     New-TypoSquatDomain -Domainname google.com 

Creates a list of alternative domains using multiple techniques.

     Get-O365TypoSquats -Domainname typosqauteddomain.com

checks if typosqauteddomain.sharepoint.com, typosqauteddomain.onmicrosoft.com and typosqauteddomain.com exists, returns true or false for each property.

## Todo

<TODO> More documentation, adding automatic spamfiltering.