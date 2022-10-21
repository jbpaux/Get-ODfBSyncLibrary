
<#
.SYNOPSIS
    Returns all synchronized libraries in OneDrive for Business of current logged-in user
.EXAMPLE
    Get-ODfBSyncLibrary
    Retrieve all configured non-personal libraries
.LINK
    https://github.com/jbpaux/Get-ODfBSyncLibrary

#>
[CmdletBinding()]
[OutputType([PSCustomObject])]
param()

$ODfBLibraries = @(Get-ChildItem -Path Registry::HKEY_CURRENT_USER\SOFTWARE\SyncEngines\Providers\OneDrive)
$Items = $ODfBLibraries | ForEach-Object { Get-ItemProperty $_.PsPath } | Where-Object { $_.LibraryType -ne "Personal" }


ForEach ($Item in $Items) {

    try { 
        $lastModifiedTime = [DateTime]::Parse($Item.LastModifiedTime)
    }
    catch {
        $lastModifiedTime = $null
    }

    [PSCustomObject]@{
        Url              = [System.Uri]$Item.UrlNamespace
        MountPoint       = [System.IO.FileInfo]$Item.MountPoint
        LibraryType      = (Get-Culture).TextInfo.ToTitleCase($Item.LibraryType)
        LastModifiedTime = $lastModifiedTime
    }
}