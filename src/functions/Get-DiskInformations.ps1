function Get-DiskInformations {
    if ($PSVersionTable.PSEdition -eq "Core") {
        return Get-CimInstance Win32_DiskDrive | ForEach-Object {
            $disk = $_
            $partitions = "ASSOCIATORS OF " + "{Win32_DiskDrive.DeviceID='$($disk.DeviceID)'} " + "WHERE AssocClass = Win32_DiskDriveToDiskPartition"
            Get-CimInstance -Query $partitions | ForEach-Object {
                $partition = $_
                $drives = "ASSOCIATORS OF " + "{Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} " + "WHERE AssocClass = Win32_LogicalDiskToPartition"
                Get-CimInstance -Query $drives | ForEach-Object {
                    New-Object -Type PSCustomObject -Property @{
                    Disk        = $disk.DeviceID
                    DiskSize    = $disk.Size
                    DiskModel   = $disk.Model
                    Partition   = $partition.Name
                    RawSize     = $partition.Size
                    DriveLetter = $_.DeviceID
                    VolumeName  = $_.VolumeName
                    Size        = $_.Size
                    FreeSpace   = $_.FreeSpace
                    }
                }
            }
        }
    } else {
        Write-Host "Your powershell edition is not supported."
        Write-Host "This function needs Powershell Core to work."
    }    
}