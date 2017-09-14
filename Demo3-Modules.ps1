Import-Module .\ModuleDemo\ModuleDemo.psd1 -Force

Get-Command -Module ModuleDemo

$controller = Connect-NcController -Name den-cdot

Get-NtapDataVolume -Controller $controller -Vserver InsightSVM