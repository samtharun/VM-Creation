# Prompt the user to select an OS flavor
$osFlavor = Read-Host "Enter the OS flavor (Windows2016, Windows2019, RHEL): "

# Define VM configuration parameters based on the selected OS flavor
if ($osFlavor -eq "Windows2016") {
    $vmName = "MyWindows2016VM"
    $imageOffer = "WindowsServer"
    $imagePublisher = "MicrosoftWindowsServer"
    $imageSku = "2016-Datacenter"
    $location = "eastus"
    $vmSize = "Standard_B2s"
}
elseif ($osFlavor -eq "Windows2019") {
    $vmName = "MyWindows2019VM"
    $imageOffer = "WindowsServer"
    $imagePublisher = "MicrosoftWindowsServer"
    $imageSku = "2019-Datacenter"
    $location = "eastus"
    $vmSize = "Standard_B2s"
}
elseif ($osFlavor -eq "RHEL") {
    $vmName = "MyRHELVM"
    $imageOffer = "RHEL"
    $imagePublisher = "RedHat"
    $imageSku = "7-RAW"
    $location = "eastus"
    $vmSize = "Standard_B2s"
}
else {
    Write-Host "Invalid OS flavor selected. Please select one of the following: Windows2016, Windows2019, RHEL"
    exit
}

# Create a new resource group
$rgName = "MyResourceGroup"
New-AzResourceGroup -Name $rgName -Location $location

# Create a new virtual network
$vnetName = "MyVnet"
$subnetName = "MySubnet"
$vnetPrefix = "10.0.0.0/16"
$subnetPrefix = "10.0.0.0/24"
New-AzVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location -AddressPrefix $vnetPrefix -Subnet $subnetName -SubnetPrefix $subnetPrefix

# Create a new public IP address
$ipName = "MyPublicIP"
New-AzPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $location -AllocationMethod Dynamic

# Create a new network security group
$nsgName = "MyNSG"
New-AzNetworkSecurityGroup -Name $nsgName -ResourceGroupName $rgName -Location $location

# Create a new NIC
$nicName = "MyNIC"
$nic = New-AzNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $location -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $ip.Id -NetworkSecurityGroupId $nsg.Id

# Create a new VM
New-AzVM -ResourceGroupName $rgName -Location $location -Name $vmName -ImageOffer $imageOffer -ImagePublisher $imagePublisher -ImageSku $imageSku -Credential (Get-Credential) -Size $vmSize -NetworkInterfaceId $nic.Id
