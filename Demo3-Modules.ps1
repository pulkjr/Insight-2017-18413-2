#region Modules

    ## Import our custom module
    Import-Module .\ModuleDemo\ModuleDemo.psd1

    ## List the functions that are available from this module
    Get-Command -Module ModuleDemo

    ## Connect to the cluster
    $controller = Connect-NcController -Name den-cdot

    ## Get the list of volumes using the custom type and format definitions
    Get-NtapDataVolume -Controller $controller -Vserver InsightSVM

#endregion