#region Modules

    ## Import our custom module
    Import-Module .\ModuleDemo\ModuleDemo.psd1

    ## List the functions that are available from this module
    Get-Command -Module ModuleDemo

    ## Connect to the cluster
    $controller = Connect-NcController -Name den-cdot -Transient

    ## Call the new function. Specify the controller object and the other necessary parameters
    New-NtapDataVolume -Controller $controller -Name 'TestCifs1' -Vserver 'InsightSVM' -Aggregate 'n1_aggr1' -Size '1g' -Protocol 'CIFS'

    ## Let's create an NFS volume too
    New-NtapDataVolume -Controller $controller -Name 'TestNfs1' -Vserver 'InsightSVM' -Aggregate 'n1_aggr1' -Size '1g' -Protocol 'NFS'

    ## Get the list of volumes using the custom type and format definitions
    Get-NtapDataVolume -Controller $controller -Vserver InsightSVM

#endregion