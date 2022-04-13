using namespace System.Management.Automation.Host

function Get-NetAdapterChoise {
    $netAdapterList = Get-NetAdapter -Name * | Select-Object Name

    $title = "Net Interface Configer"
    $message = "Choose network interface"

    [System.Management.Automation.Host.ChoiceDescription[]] $choicesOptions = $netAdapterList | ForEach-Object {
        New-Object System.Management.Automation.Host.ChoiceDescription "&$($_.Name)", "Choose $($_.Name) net adapter."
    }
    $chosenNetAdapterIndex = $host.ui.PromptForChoice($title, $message, $choicesOptions, 0)

    return $netAdapterList[$chosenNetAdapterIndex].Name 
}

function Get-UtilChoise {
    $title = "Net Interface Configer"
    $message = "Choose util"
    $utils = @(
        ("&Auto setup", "Automatic configuration of the selected interface by the DHCP server"),
        ("&Static setup", "Manual configuration of the selected interface"),
        ("&Net card model", "Network card model of the selected interface"),
        ("&Check link", "Checks for a physical connection (link) of the selected interface"),
        ("&Duplex & Speed", "Display the speed and mode of operation of the adapter (speed, duplex) of the selected interface")
    )
    
    [System.Management.Automation.Host.ChoiceDescription[]] $choicesUtils = $utils | ForEach-Object {
        New-Object System.Management.Automation.Host.ChoiceDescription $_
    }
    
    return $host.ui.PromptForChoice($title, $message, $choicesUtils, 0)
}

function Set-NetInterface($netAdapter) {
    $ipParams = @{
        InterfaceIndex = $netAdapter
        IPAddress = Read-Host "Enter ip-address"
        PrefixLength = Read-Host "Enter mask (in a prefix length form)"
        DefaultGateway = Read-Host "Enter gateway"
        AddressFamily = "IPv4"
    }
    New-NetIPAddress @ipParams

    $dnsParams = @{
        InterfaceIndex = $netAdapter
        ServerAddresses = Read-Host "Enter dns"
    }
    Set-DnsClientServerAddress @dnsParams
}

$netAdapter = Get-NetAdapterChoise
$util = Get-UtilChoise

switch ($util) {
    0 { Get-NetAdapter -Name $netAdapter | Set-NetIPInterface -Dhcp Enabled }
    1 { Set-NetInterface $netAdapter }
    2 { Get-NetAdapter -Name $netAdapter | Format-List -Property "InterfaceDescription" }
    3 { Get-NetAdapter -Name $netAdapter | Format-List -Property "Status" }
    4 { Get-NetAdapter -Name $netAdapter | Format-List -Property "FullDuplex", "LinkSpeed" }
}