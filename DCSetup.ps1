# Choco install and Choco Apps
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install googlechrome -y
choco install putty -y
choco install notepadplusplus -y
choco install winscp -y
choco install sysinternals -y
choco install bginfo -y
# Download Scripts to Set the rest of the Domain up when logged in
New-Item -Path "c:\" -Name "BaselabSetup" -ItemType "directory" -Force
Invoke-WebRequest -Uri "https://github.com/chandanchanchal/devops/blob/master/baselab_DomainSetup.ps1" -OutFile "C:\BaselabSetup\baselab_DomainSetup.ps1"
Invoke-WebRequest -Uri "https://github.com/chandanchanchal/devops/blob/master/baselab_LabStructure.ps1" -OutFile "C:\BaselabSetup\baselab_LabStructure.ps1"
# Setup and Partition Data Disk
Get-Disk | Where partitionstyle -eq 'raw' | Initialize-Disk -PartitionStyle MBR -PassThru | New-Partition -AssignDriveLetter -UseMaximumSize | Format-Volume -FileSystem NTFS -NewFileSystemLabel 'Data' -Confirm:$false 
# Allow Ping
Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)" -enabled True
Set-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv6-In)" -enabled True
# Install Roles to make Server a Domain Controller
Install-windowsfeature -name AD-Domain-Services -IncludeManagementTools
Install-windowsfeature -name DNS -IncludeManagementTools
