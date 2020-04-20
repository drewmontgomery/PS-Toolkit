function Get-SystemInformations {
    if ($PSVersionTable.PSEdition -eq "Core") {
        if ($PSVersionTable.OS -match "Windows") {
            $windowsInformations = Get-CimInstance -ClassName Win32_OperatingSystem
            $memory = Convert-DataByte -Value $windowsInformations.TotalVisibleMemorySize -To MB

            Write-Host "System informations"
            Write-Host "-------------------"

            Write-Host "Computer Name :" $env:COMPUTERNAME
            Write-Host "Product ID :" $windowsInformations.SerialNumber
            Write-Host "OS Type" : $windowsInformations.OSArchitecture
            Write-Host

            Write-Host "Windows specifications"
            Write-Host "----------------------"
            
            Write-Host "Windows edition :" $windowsInformations.Caption
            Write-Host "Windows version :" (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ReleaseId).ReleaseId
            Write-Host "OS version :" $windowsInformations.Version
            Write-Host "Install Date :" $windowsInformations.InstallDate
            Write-Host

            Write-Host "Hardware informations"
            Write-Host "---------------------"
            Write-Host "Processor :" (Get-CimInstance -ClassName Win32_Processor).Name
            Write-Host "Available RAM :" $memory "GB"
            Write-Host "Graphic card :" (Get-CimInstance -ClassName Win32_VideoController).Caption
            Write-Host "Disks list :"

            foreach ($disk in Get-DiskInformations) {
                $size = Convert-DataByte -Value $disk.Size -To GB
                Write-Host "    •" $disk.DiskModel "(Letter"$disk.DriveLetter"- Size :" $size "GB)" 
            }

        } else {
            Write-Host "This OS is not supported."
        }
    } else {
        Write-Host "Your powershell edition is not supported."
        Write-Host "This function needs Powershell Core to work."
    }    
}