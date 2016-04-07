@{
    ModuleVersion     = '2016.4.7'
	PrivateData       = @{
        PSData = @{
            # ReleaseNotes of this module
            ReleaseNotes = 'Fixed issue with Get-BitlockerKey function.'

            # Tags applied to this module. These help with module discovery in online galleries.
            # Tags = @()

            # A URL to the license for this module.
            # LicenseUri = ''

            # A URL to the main website for this project.
            # ProjectUri = ''

            # A URL to an icon representing this module.
            # IconUri = ''
        }
    }
    GUID              = 'd7a7df2e-b156-4992-a7f9-c7f66a5d823a'
    Author            = 'Adrian Rodriguez'
	Description       = 'PowerShell module for performing various tasks.'
    Copyright         = '(c) 2015 Adrian Rodriguez. All rights reserved.'
    PowerShellVersion = '5.0'
    RequiredModules   = @()
	RootModule        = '.\ARTools.psm1'
    TypesToProcess    = '.\ARtools.ps1xml'
    FormatsToProcess  = '.\ARTools.format.ps1xml'
    NestedModules     = @()
    FunctionsToExport = @(
        'Add-LocalGroupMember',
		'Add-WorkstationPrinter',
		'Confirm-ADGroupMembership',
		'Connect-ConfigMgr',
		'Connect-Exchange',
		'Connect-Lync',
		'Connect-RDP',
		'Connect-Viewer',
		'ConvertFrom-EncodedCommand',
		'ConvertTo-EncodedCommand',
		'Disable-User',
		'Disconnect-LoggedOnUser',
		'Enable-RemotePSRemoting',
		'Find-AlternateEmailAddress',
		'Find-ErrorEventLog',
		'Find-UnquotedServicePath',
		'Get-ADGroupMembershipTree',
		'Get-ADPrincipalGroupMembershipTree',
		'Get-BitlockerKey',
		'Get-ConfigMgrAppInfo',
		'Get-DellWarranty',
		'Get-DomainPC',
		'Get-InstalledProgram',
		'Get-IPAddressRange',
		'Get-LocalGroupMembership',
		'Get-LockOutInfo',
		'Get-LoggedOnUser',
		'Get-MailboxFolderSize',
		'Get-Phonetic',
		'Get-ServiceExecutablePermission',
		'Get-StaleDomainUser',
		'Get-StaleLocalUser',
		'Get-WorkstationPrinter',
		'Import-Credential',
		'Invoke-ConfigMgrInstallation',
		'Invoke-ConfigMgrUpdate',
		'Invoke-Installation',
		'Invoke-WSUSCheckIn',
		'New-AudioNotification',
		'New-EchosignUser',
		'New-RandomPassword',
		'New-User',
		'New-VisualNotification',
		'Remove-Installation',
		'Remove-LocalGroupMember',
		'Remove-Signature',
		'Remove-UserProfile',
		'Remove-WorkstationPrinter',
		'Repair-Installation',
		'Reset-ADPassword',
		'Reset-WindowsUpdate',
		'Save-Credential',
		'Search-ADAccountByName',
		'Send-NetMessage',
		'Set-Signature',
		'Split-Array',
		'Start-VSDiffMerge',
		'Test-Ping',
		'Test-SNMPCommunityString',
		'Test-TCPPort',
		'Update-ConfigMgrApplicationDeploymentTypeScript'
    )
    CmdletsToExport   = '*'
    VariablesToExport = '*'
    AliasesToExport   = '*'
}
