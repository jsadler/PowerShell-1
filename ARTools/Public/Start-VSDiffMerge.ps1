function Start-VSDiffMerge{
	[cmdletbinding()]

	Param(
		[Parameter(Mandatory = $True,Position=0)]
		[System.IO.FileInfo]$ReferenceFile,

		[Parameter(Mandatory = $True,Position=1)]
		[System.IO.FileInfo]$DifferenceFile
	)

	Begin{}

	Process{
		$ReferenceFile, $DifferenceFile |
		ForEach-Object -Process{
			If(-not $_.Exists){Write-Warning -Message "Cannot find path '$($_.FullName)'.";Break}
		}

		If($DTE){
			$DTE.ExecuteCommand("Tools.DiffFiles", "`"$($ReferenceFile.fullname)`" `"$($DifferenceFile.fullname)`"")
		}
		Else{
			Write-Warning -Message "Please run Start-VSDiffMerge from Visual Studio."
		}
	}

	End{}
}
# SIG # Begin signature block
# MIISDAYJKoZIhvcNAQcCoIIR/TCCEfkCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUSQKO7olsP+KZdOaFaVz6inxe
# aG6ggg3cMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
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
# KwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcNAQkEMRYEFHVCXO2N
# iH030PzT2XFYHkJOJHD1MA0GCSqGSIb3DQEBAQUABIGAaciKhR8Br13JokwItt/q
# uB0QslD6hYG1vDftUYQK4j95kvqIaPtjFh3eraAya402qggqRvAO6un/B0FSrXdb
# B544u0fsiEhpK/UbGfte24UuDp9+av6F39D0Oq79tYiOuqmjXwL0+XspArYJiHH1
# WYUDk71DMhGCXaHQBhaJwcGhggILMIICBwYJKoZIhvcNAQkGMYIB+DCCAfQCAQEw
# cjBeMQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24x
# MDAuBgNVBAMTJ1N5bWFudGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBH
# MgIQDs/0OMj+vzVuBNhqmBsaUDAJBgUrDgMCGgUAoF0wGAYJKoZIhvcNAQkDMQsG
# CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTYwMTA4MTMyNzEzWjAjBgkqhkiG
# 9w0BCQQxFgQU/oDcrCXwdpIBCDXcOJl+2aWr1NIwDQYJKoZIhvcNAQEBBQAEggEA
# e0uJFIv+doW8GDOCnEUHXH+5q1Pn+zGH7HqZetefulW/1K0mpW5bKqHPe+XmO+d6
# OxS6KGvYmPAspSfgV4t7NYjktRNFaMV/IzPqmBuXOgqXW4EAr0M3zaH1Dtk9ZxV2
# hut4G7xAi0albqapTqm3/SV7JQCykqCnzII2s5yfvvEB803+QjIbppVBx4R5jua5
# SkxW+9hduWmLTglN3D8tVO42p1FUTsxJ1OmH7ieL6GkLBZzWoKQuTKRyZIwx36Rm
# dpvO5i1o5/rgmp+tMxNkt0xFKKQoU1VD1ySrZ0PYJBY8ViR9X1TQ7csolGNNx5s3
# ZivzkhBNF3iFdaZ3ebujXA==
# SIG # End signature block