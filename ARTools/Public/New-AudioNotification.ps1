﻿#requires -Version 2
function New-AudioNotification
{
    [CmdletBinding(SupportsShouldProcess = $True,ConfirmImpact = 'Low')]
    
    Param(
        [Parameter(Mandatory = $False,ValueFromPipeline)]
        [string]$Message = 'Attention. Task Completed.'
    )
    
    Begin{
        $AudioControl = @'
using System.Runtime.InteropServices;
[Guid("5CDF2C82-841E-4546-9722-0CF74078229A"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IAudioEndpointVolume {
  // f(), g(), ... are unused COM method slots. Define these if you care
  int f(); int g(); int h(); int i();
  int SetMasterVolumeLevelScalar(float fLevel, System.Guid pguidEventContext);
  int j();
  int GetMasterVolumeLevelScalar(out float pfLevel);
  int k(); int l(); int m(); int n();
  int SetMute([MarshalAs(UnmanagedType.Bool)] bool bMute, System.Guid pguidEventContext);
  int GetMute(out bool pbMute);
}
[Guid("D666063F-1587-4E43-81F1-B948E807363F"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDevice {
  int Activate(ref System.Guid id, int clsCtx, int activationParams, out IAudioEndpointVolume aev);
}
[Guid("A95664D2-9614-4F35-A746-DE8DB63617E6"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
interface IMMDeviceEnumerator {
  int f(); // Unused
  int GetDefaultAudioEndpoint(int dataFlow, int role, out IMMDevice endpoint);
}
[ComImport, Guid("BCDE0395-E52F-467C-8E3D-C4579291692E")] class MMDeviceEnumeratorComObject { }
public class Audio {
  static IAudioEndpointVolume Vol() {
    var enumerator = new MMDeviceEnumeratorComObject() as IMMDeviceEnumerator;
    IMMDevice dev = null;
    Marshal.ThrowExceptionForHR(enumerator.GetDefaultAudioEndpoint(/*eRender*/ 0, /*eMultimedia*/ 1, out dev));
    IAudioEndpointVolume epv = null;
    var epvid = typeof(IAudioEndpointVolume).GUID;
    Marshal.ThrowExceptionForHR(dev.Activate(ref epvid, /*CLSCTX_ALL*/ 23, 0, out epv));
    return epv;
  }
  public static float Volume {
    get {float v = -1; Marshal.ThrowExceptionForHR(Vol().GetMasterVolumeLevelScalar(out v)); return v;}
    set {Marshal.ThrowExceptionForHR(Vol().SetMasterVolumeLevelScalar(value, System.Guid.Empty));}
  }
  public static bool Mute {
    get { bool mute; Marshal.ThrowExceptionForHR(Vol().GetMute(out mute)); return mute; }
    set { Marshal.ThrowExceptionForHR(Vol().SetMute(value, System.Guid.Empty)); }
  }
}
'@
    }
    
    Process{
        If($PSCmdlet.ShouldProcess("Message: $Message"))
        {
            Add-Type -TypeDefinition $AudioControl
        
            $IsMuted = [audio]::Mute
            $CurrentVolume = [audio]::Volume
        
            If($IsMuted)
            {
                [audio]::Mute = $False
            }
        
            [audio]::Volume = 1
        
            Add-Type -AssemblyName System.speech
            $SpeechSynthesizer = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
        
            $SpeechSynthesizer.Speak($Message)
            
            [audio]::Volume = $CurrentVolume
        
            If($IsMuted)
            {
                [audio]::Mute = $True
            }
        }
    }
    
    End{}
}

# SIG # Begin signature block
# MIIVqAYJKoZIhvcNAQcCoIIVmTCCFZUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUbUn5cPhNVolE3QHGHNQslo0W
# u/ygghF4MIIDmDCCAoCgAwIBAgIQFTuOD6CJ+6NFVKZ6+fJQbzANBgkqhkiG9w0B
# AQUFADBUMRMwEQYKCZImiZPyLGQBGRYDb3JnMR0wGwYKCZImiZPyLGQBGRYNYmxh
# Y2toaWxsc2ZjdTEeMBwGA1UEAxMVYmxhY2toaWxsc2ZjdS1CSENBLUNBMB4XDTEz
# MTIzMTIzMTgxMloXDTI4MTIzMTIzMjgxMlowVDETMBEGCgmSJomT8ixkARkWA29y
# ZzEdMBsGCgmSJomT8ixkARkWDWJsYWNraGlsbHNmY3UxHjAcBgNVBAMTFWJsYWNr
# aGlsbHNmY3UtQkhDQS1DQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEB
# ANliX6Op+J0AilINTvsinTTROSxyz/PYuja5257UdIUqCyIjiZ+0GA+jLcKjU12y
# ijfQaQs9g/hQp3/BFxDtxXIfXVZ2pDTLPCdIecPgv8BbmFl09wHvD87h+fkqMddR
# l4GBQI0YWGF4Ntb3fypW4+9MOHIViAxwbxHIiqC4MICl764xAWNEjYXcVAOpnRb2
# EiqQG0xieg/D2kdYl1UpFmiLwMj/C5GgtllopHggEEN8KSas1Zzus7MQBHBq+QLd
# UvmuDo5fkCa3JN+1gmsxz2yTaIK1gRRpNZJH1/55EJ2iYfYT330Oi0i2CJzHHbki
# MCvci1Bw9NE0gs31FUrmY5cCAwEAAaNmMGQwEwYJKwYBBAGCNxQCBAYeBABDAEEw
# CwYDVR0PBAQDAgGGMA8GA1UdEwEB/wQFMAMBAf8wHQYDVR0OBBYEFF/X6Uf5osbZ
# bSp9/Vsx1FcTcWzlMBAGCSsGAQQBgjcVAQQDAgEAMA0GCSqGSIb3DQEBBQUAA4IB
# AQAn5UDeAopPF/wpu5SL5DV7BrrvSvSDg1fmVHq5DKanQMp2rycfi51/W0RFwSHu
# LVaoUajhCl0GfX2ODHvLvKBJUxOSxienx9AaXkpi92nM85/qDeMzviQQRrcVTxj1
# Zt+/fJf4hKtlmuj+Yf/rMP2EU3nAr57YAO0FOFDkTHJu03/lx21aEUMLBlKDMdiq
# 4sJbbmoAFsYj7kmK5dCFTi1PwWocvgO1Ap5E1oV4SULAO+9LtFr4ISnfgL9m5gwD
# XPJXPQmHSIwAI6V97BDdRLahbC4RBp7oOvTQWOPvu0cx2yTcxmvQq1hPODivah3H
# qFWseGOy066WYThhNGBiuN0TMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8
# OzANBgkqhkiG9w0BAQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rl
# cm4gQ2FwZTEUMBIGA1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEd
# MBsGA1UECxMUVGhhd3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBU
# aW1lc3RhbXBpbmcgQ0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBe
# MQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAu
# BgNVBAMTJ1N5bWFudGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCC
# ASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcq
# b9y4JsRDc2vCvy5QWvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRr
# zV9FO9FEzkMScxeCi2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ
# 5/6M4lc/PcaS3Er4ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTa
# wIHwHw103pIiq8r3+3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrl
# Dqcsn6plINPYlujIfKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXEC
# AwEAAaOB+jCB9zAdBgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYB
# BQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIG
# A1UdEwEB/wQIMAYBAf8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50
# aGF3dGUuY29tL1RoYXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggr
# BgEFBQcDCDAOBgNVHQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMT
# EFRpbWVTdGFtcC0yMDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9o
# tfrjCR27T4IGXTdfplKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuw
# GsOO61mWAK3ODE2y0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlX
# Px13SYcqFgZepjhqIhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqY
# GxpQMA0GCSqGSIb3DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1h
# bnRlYyBDb3Jwb3JhdGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGlu
# ZyBTZXJ2aWNlcyBDQSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1
# OVowYjELMAkGA1UEBhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9u
# MTQwMgYDVQQDEytTeW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25l
# ciAtIEc0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOn
# REm7Dv+h8GEKU5OwmNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBD
# SyKV7sIrQ8Gf2Gi0jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4ky
# W7BemVqonShQDhfultthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9
# JYDh6NIipdC6Anqhd5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aL
# M73ZY8hJnTrFxeozC9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+Z
# COEQKHKqzQIDAQABo4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAK
# BggrBgEFBQcDCDAOBgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsG
# AQUFBzABhh5odHRwOi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUH
# MAKGK2h0dHA6Ly90cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIw
# PAYDVR0fBDUwMzAxoC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20v
# dHNzLWNhLWcyLmNybDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1w
# LTIwNDgtMjAdBgNVHQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgw
# FoAUX5r1blzMzHSa1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEq
# AEzwj2IwN3ijhCcHbxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9Cwm
# YzPkSWRtDebDZw73BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgE
# IKOq8UvEiCmRDoDREfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2
# DBYr8X9bCT2bW+IWyhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4ax
# gohd8D20UaF5Mysue7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzF
# HTx/kuDDvBzYBHUwggU/MIIEJ6ADAgECAhN4AAAAc4W2eXB+zY31AAAAAABzMA0G
# CSqGSIb3DQEBBQUAMFQxEzARBgoJkiaJk/IsZAEZFgNvcmcxHTAbBgoJkiaJk/Is
# ZAEZFg1ibGFja2hpbGxzZmN1MR4wHAYDVQQDExVibGFja2hpbGxzZmN1LUJIQ0Et
# Q0EwHhcNMTUwODEyMjMxNDM4WhcNMTYwODExMjMxNDM4WjB0MRMwEQYKCZImiZPy
# LGQBGRYDb3JnMR0wGwYKCZImiZPyLGQBGRYNYmxhY2toaWxsc2ZjdTEWMBQGA1UE
# CxMNVXNlciBBY2NvdW50czELMAkGA1UECxMCSVQxGTAXBgNVBAMTEEFkcmlhbiBS
# b2RyaWd1ZXowgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAJ5ZDMvhBWGsWxF+
# 1tGMRbvdsQx9th2SoTrEa4TGjPJo1S+NtPGditPNBlsJO9G/NhucjSwAT2Vc7/7a
# GQjNPaF3SyYwhSxVNfJjFqtpZjBgsxXDA4GlLYESC5LZ32ZR6ettkUSeHt/qXLAm
# 3hBJGca6FjTvO5lkayiqeZr9iRWnAgMBAAGjggJsMIICaDAlBgkrBgEEAYI3FAIE
# GB4WAEMAbwBkAGUAUwBpAGcAbgBpAG4AZzATBgNVHSUEDDAKBggrBgEFBQcDAzAL
# BgNVHQ8EBAMCB4AwHQYDVR0OBBYEFAhHzZ02lmNv/fQPGxn1kyQ8cmzlMB8GA1Ud
# IwQYMBaAFF/X6Uf5osbZbSp9/Vsx1FcTcWzlMIHWBgNVHR8Egc4wgcswgciggcWg
# gcKGgb9sZGFwOi8vL0NOPWJsYWNraGlsbHNmY3UtQkhDQS1DQSxDTj1CSENBLENO
# PUNEUCxDTj1QdWJsaWMlMjBLZXklMjBTZXJ2aWNlcyxDTj1TZXJ2aWNlcyxDTj1D
# b25maWd1cmF0aW9uLERDPWJsYWNraGlsbHNmY3UsREM9b3JnP2NlcnRpZmljYXRl
# UmV2b2NhdGlvbkxpc3Q/YmFzZT9vYmplY3RDbGFzcz1jUkxEaXN0cmlidXRpb25Q
# b2ludDCBzQYIKwYBBQUHAQEEgcAwgb0wgboGCCsGAQUFBzAChoGtbGRhcDovLy9D
# Tj1ibGFja2hpbGxzZmN1LUJIQ0EtQ0EsQ049QUlBLENOPVB1YmxpYyUyMEtleSUy
# MFNlcnZpY2VzLENOPVNlcnZpY2VzLENOPUNvbmZpZ3VyYXRpb24sREM9YmxhY2to
# aWxsc2ZjdSxEQz1vcmc/Y0FDZXJ0aWZpY2F0ZT9iYXNlP29iamVjdENsYXNzPWNl
# cnRpZmljYXRpb25BdXRob3JpdHkwNAYDVR0RBC0wK6ApBgorBgEEAYI3FAIDoBsM
# GWFkcmlhbnJAYmxhY2toaWxsc2ZjdS5vcmcwDQYJKoZIhvcNAQEFBQADggEBAJuf
# qHfcfbsgqU+3d0vNNHCeAF59ygRRQX55uPiATRt3KAaEah79BmwzmzvA1n4WBh4f
# sGwNSpzEl2cBChCANARhRh0018QpExSid+l3EEWg9jNFqRSkgDFz9UmTsIjPiXWk
# XPJzTtoyG/Ga0hcpOl/Lx7niAIfmxQcBmOsLXKsSlnrfmeiaBhB+D+K2fELmMuEs
# EiEIZeeV3A5/U4MbVFBa4OOhK2jiZzQgvjDDXwMs8MRYHFG5Y9rFE8wDHq21aLMY
# AItRKXqNOvGtq5bXZUJM+ZakmWBJhy/q7j451vxXcs1QmCJpOWgD5OpXK3TvycAa
# Iq7iiOlcvjMyOL3kdqkxggOaMIIDlgIBATBrMFQxEzARBgoJkiaJk/IsZAEZFgNv
# cmcxHTAbBgoJkiaJk/IsZAEZFg1ibGFja2hpbGxzZmN1MR4wHAYDVQQDExVibGFj
# a2hpbGxzZmN1LUJIQ0EtQ0ECE3gAAABzhbZ5cH7NjfUAAAAAAHMwCQYFKw4DAhoF
# AKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZIhvcNAQkDMQwGCisG
# AQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcCARUwIwYJKoZIhvcN
# AQkEMRYEFJ2TwbG3Jv5nMfwWC2x84z9oY0/jMA0GCSqGSIb3DQEBAQUABIGAbxcm
# WIogYkiOYYKhpwfOYX+EwEADWycBeK5aXu+uGIBj63eZyKfKQVSJwdLtdvGGnZ7H
# 2LEhjHpzA+gR2s3InVZ+JETEbolMddtLu+Zc8gzXhy8IZnrIhtPdRrF+lMGsRJEE
# Z3ZQN+MvTBqHLkSvhkMeNYophoB0exRzehOmPLehggILMIICBwYJKoZIhvcNAQkG
# MYIB+DCCAfQCAQEwcjBeMQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMg
# Q29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFudGVjIFRpbWUgU3RhbXBpbmcgU2Vy
# dmljZXMgQ0EgLSBHMgIQDs/0OMj+vzVuBNhqmBsaUDAJBgUrDgMCGgUAoF0wGAYJ
# KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjEwMjEz
# MzQ2WjAjBgkqhkiG9w0BCQQxFgQUXYzauTk3WVyu7rMtguGS1A/gbpwwDQYJKoZI
# hvcNAQEBBQAEggEAEaFYqDpQVrcl8sXnHfYNgRNkos0q/QjSwxEsAD/ze03CWS1v
# FtqR5UfHbb3HJNjXBJoaB1bv6yFHs59kkD55E3t6Skthgjh+Iwr8v3POgiD8pvJf
# 9AxnW174r7Os88qTXG7ry+PXplRt7RiRV5XI/WVd0/1pEQ/RHDLP9MeJaKDbfWGD
# SH/LMGhAMg7RZKXlJJr2UeDyoJaUaGYtKkkJMLGXaFA/CcAsVIFHPRNvcOrihnTZ
# jCqFxw9XzDcQtPprNO2jYjYqHqhSLfJ141tgB2wIrhzW7yEzNGOqR9FIXTg6DDzO
# /87XTlZm0JADR54sDGUeTX1HoLEYXL542qdKCQ==
# SIG # End signature block
