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

		Script DownloadScript
		{
            GetScript = 
            {
                @{
                    GetScript = $GetScript
                    SetScript = $SetScript
                    TestScript = $TestScript
                    Result = ('True' -in (Test-Path C:\Scripts\Import-AllModules.ps1))
                }
            }

            SetScript = 
            {
                Invoke-WebRequest -Uri "https://sondrestorage.blob.core.windows.net/tempstorage/Import-AllModules.ps1" -OutFile "C:\Scripts\Import-AllModules.ps1"
            }

            TestScript = 
            {
                $Status = ('True' -in (Test-Path c:\Scripts\Import-AllModules.ps1))
                $Status -eq $True
            }
        }
    }
} 