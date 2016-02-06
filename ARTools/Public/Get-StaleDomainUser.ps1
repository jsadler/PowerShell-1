﻿#requires -Version 2
function Get-StaleDomainUser
{
    <#
            .Synopsis
            Displays domain user accounts whose passwords have not been changed in a given number of days.

            .DESCRIPTION
            The Get-StaleDomainUser function displays all domain user acounts whose passwords have not been changed in a given number of days.
    
            By default this function displays domain user accounts that are enabled and whose password age has exceeded the maximum password age of the current domain.

            .EXAMPLE
            PS C:\> Get-StaleDomainUser

            This command displays all domain user accounts that are enabled and whose password age has exceeded the maximum password age of the current domain. 

            .EXAMPLE
            PS C:\> Get-StaleDomainUser -IncludeDisabled | Export-csv -Path c:\DomainUsers.csv

            This command displays all domain user accounts (both enabled and disabled) whose password age has exceeded the maximum password age of the current domain. The results are then exported to a CSV file named DomainUsers.csv at the root of the C drive.
    
            .EXAMPLE
            PS C:\> Get-StaleDomainUser

            This command displays all domain user accounts that are enabled and whose password age has exceeded the maximum password age of the current domain. 

            .NOTES
            The Get-StaleDomainUser function requires the ActiveDirectory module to be installed. This module can be obtained by installing the Remote Server Administration Tools on one's computer.
    
            .PARAMETER DaysOld
            Specifies the maximum password age in number of days. The default is the maximum password age of the current domain.
    
            .PARAMETER IncludeDisabled
            Specifies the function return disabled domain user accounts as well.

    #>
    
    [cmdletbinding()]
    
    Param(
        [Parameter(Mandatory = $False)]
        [int]$DaysOld = (Get-ADDefaultDomainPasswordPolicy -Identity $env:USERDNSDOMAIN).MaxPasswordAge.Days,
        
        [Parameter(Mandatory = $False)]
        [switch]$IncludeDisabled
    )
    
    Begin{}
    
    Process{
        Get-ADUser -Filter * -Properties pwdLastSet, PasswordNeverExpires, PasswordNotRequired, Description |
        Select-Object -Property *, @{
            n = 'LastPasswordSet'
            e = {
                [datetime]::FromFileTime($_.pwdlastset)
            }
        } | 
        Where-Object -FilterScript {
            $_.LastPasswordSet -le (Get-Date).AddDays($(-$DaysOld))
        } |
        Select-Object -Property Name, @{
            n = 'Username'
            e = {
                $_.samaccountname
            }
        }, Enabled, Description, LastPasswordSet, PasswordNeverExpires, PasswordNotRequired |
        ForEach-Object -Process {
            $Object  = $_
            If($IncludeDisabled)
            {
                $Object
            }
            Else
            {
                $Object |
                Where-Object -FilterScript {
                    $_.Enabled -eq $True
                }
            }
        }
    }
    
    End{}
}


# SIG # Begin signature block
# MIISDAYJKoZIhvcNAQcCoIIR/TCCEfkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU+Nuak92hzpDC4Ktn4b82L/pE
# 1hyggg3cMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggU/MIIEJ6ADAgECAhN4AAAAc4W2eXB+zY31AAAAAABzMA0GCSqGSIb3DQEBBQUA
# MFQxEzARBgoJkiaJk/IsZAEZFgNvcmcxHTAbBgoJkiaJk/IsZAEZFg1ibGFja2hp
# bGxzZmN1MR4wHAYDVQQDExVibGFja2hpbGxzZmN1LUJIQ0EtQ0EwHhcNMTUwODEy
# MjMxNDM4WhcNMTYwODExMjMxNDM4WjB0MRMwEQYKCZImiZPyLGQBGRYDb3JnMR0w
# GwYKCZImiZPyLGQBGRYNYmxhY2toaWxsc2ZjdTEWMBQGA1UECxMNVXNlciBBY2Nv
# dW50czELMAkGA1UECxMCSVQxGTAXBgNVBAMTEEFkcmlhbiBSb2RyaWd1ZXowgZ8w
# DQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAJ5ZDMvhBWGsWxF+1tGMRbvdsQx9th2S
# oTrEa4TGjPJo1S+NtPGditPNBlsJO9G/NhucjSwAT2Vc7/7aGQjNPaF3SyYwhSxV
# NfJjFqtpZjBgsxXDA4GlLYESC5LZ32ZR6ettkUSeHt/qXLAm3hBJGca6FjTvO5lk
# ayiqeZr9iRWnAgMBAAGjggJsMIICaDAlBgkrBgEEAYI3FAIEGB4WAEMAbwBkAGUA
# UwBpAGcAbgBpAG4AZzATBgNVHSUEDDAKBggrBgEFBQcDAzALBgNVHQ8EBAMCB4Aw
# HQYDVR0OBBYEFAhHzZ02lmNv/fQPGxn1kyQ8cmzlMB8GA1UdIwQYMBaAFF/X6Uf5
# osbZbSp9/Vsx1FcTcWzlMIHWBgNVHR8Egc4wgcswgciggcWggcKGgb9sZGFwOi8v
# L0NOPWJsYWNraGlsbHNmY3UtQkhDQS1DQSxDTj1CSENBLENOPUNEUCxDTj1QdWJs
# aWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1Db25maWd1cmF0aW9u
# LERDPWJsYWNraGlsbHNmY3UsREM9b3JnP2NlcnRpZmljYXRlUmV2b2NhdGlvbkxp
# c3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRpb25Qb2ludDCBzQYIKwYB
# BQUHAQEEgcAwgb0wgboGCCsGAQUFBzAChoGtbGRhcDovLy9DTj1ibGFja2hpbGxz
# ZmN1LUJIQ0EtQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUyMFNlcnZpY2VzLENO
# PVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9YmxhY2toaWxsc2ZjdSxEQz1v
# cmc/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNlcnRpZmljYXRpb25B
# dXRob3JpdHkwNAYDVR0RBC0wK6ApBgorBgEEAYI3FAIDoBsMGWFkcmlhbnJAYmxh
# Y2toaWxsc2ZjdS5vcmcwDQYJKoZIhvcNAQEFBQADggEBAJufqHfcfbsgqU+3d0vN
# NHCeAF59ygRRQX55uPiATRt3KAaEah79BmwzmzvA1n4WBh4fsGwNSpzEl2cBChCA
# NARhRh0018QpExSid+l3EEWg9jNFqRSkgDFz9UmTsIjPiXWkXPJzTtoyG/Ga0hcp
# Ol/Lx7niAIfmxQcBmOsLXKsSlnrfmeiaBhB+D+K2fELmMuEsEiEIZeeV3A5/U4Mb
# VFBa4OOhK2jiZzQgvjDDXwMs8MRYHFG5Y9rFE8wDHq21aLMYAItRKXqNOvGtq5bX
# ZUJM+ZakmWBJhy/q7j451vxXcs1QmCJpOWgD5OpXK3TvycAaIq7iiOlcvjMyOL3k
# dqkxggOaMIIDlgIBATBrMFQxEzARBgoJkiaJk/IsZAEZFgNvcmcxHTAbBgoJkiaJ
# k/IsZAEZFg1ibGFja2hpbGxzZmN1MR4wHAYDVQQDExVibGFja2hpbGxzZmN1LUJI
# Q0EtQ0ECE3gAAABzhbZ5cH7NjfUAAAAAAHMwCQYFKw4DAhoFAKB4MBgGCisGAQQB
# gjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisGAQQBgjcCAQQwHAYK
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFNvfBnbJ
# cnxURDK0Jdj5xd0uQeJpMA0GCSqGSIb3DQEBAQUABIGAm4p7++pb1SpSI8f0orNH
# M6FZg2JSFU0u7XLdNuBxHYy+DCeB8Ae27olsCeukfUvGEMe++YuUEpilKhrW2p6h
# itOPmcCmL3hQ2LquM299cjOcYi98tDjaH6oJbztlLDHH6PWuO/qchKduVkNhakDe
# wJlmC8D33gXRMMi3HiiSDY2hggILMIICBwYJKoZIhvcNAQkGMYIB+DCCAfQCAQEw
# cjBeMQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24x
# MDAuBgNVBAMTJ1N5bWFudGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBH
# MgIQDs/0OMj+vzVuBNhqmBsaUDAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsG
# CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwMTA4MTMxNjA1WjAjBgkqhkiG
# 9w0BCQQxFgQUaiwjf16FoCQz7nlfA2b4Oa++0TEwDQYJKoZIhvcNAQEBBQAEggEA
# Ilgglojy4PxNT3EcYmExlsTYxv8zWDnDxhG+aJRMr8hDGECBiHiSn29AX7tTOC7X
# BtqE+Ytz5jfW/Gbwr4/eEvPbPRW36GC9vVUrCafepg/IBzVTqhJUwF3fKuW+NHhK
# RlHlVoQ2ikMePP/ht/DTw+BJSo5FiROOZY1TDlkAHPmzlqt1E7x222qayfoLGsqT
# Q39MgfQmkxNzhbI0HM+8/x2CZZJ4q9wsbMdxA1oN+/m6rYMBfUbo4WyhGkXpUUeV
# hwfvXTjDTxbFrgRpTeFqKDLBItuZFmUrm59amIqVeEGiNmCwgQF7A5t5sTWE3qrw
# bpkPudmZSyEOZ/BekL6oLw==
# SIG # End signature block