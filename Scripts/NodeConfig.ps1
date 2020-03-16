Configuration NodeConfig {

    # Import the module that contains the resources we're using.
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    # The Node statement specifies which targets this configuration will be applied to.
    Node 'localhost' {
        File ScriptFolder 
        {
            Type = "Directory"
            Ensure = "Present"
            DestinationPath = "C:\Scripts"
        }

        Script DownloadAndExecuteScript
        {
            GetScript = 
            {
                @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = ('True' -in (Test-Path C:\Scripts\Install-CniPlugin.ps1))
                }
            }

            SetScript = 
            {
                Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Oldervoll/kubethings/master/Scripts/Install-CniPlugin.ps1" -OutFile "C:\Scripts\Install-CniPlugin.ps1"
                Invoke-Expression -Command "C:\Scripts\Install-CniPlugin.ps1 v1.0.33"
            }

            TestScript = 
            {
                $Status = ('True' -in (Test-Path c:\Scripts\Install-CniPlugin.ps1))
                $Status -eq $True
            }
        }
    }
} 