 #Create a virtual machine configuration object and then create the VM. The following command creates a SQL Server 2017 Developer Edition VM on Windows Server 2016

# Create a virtual machine configuration
$VMName = $ResourceGroupName + "VM"
$VMConfig = New-AzVMConfig -VMName $VMName -VMSize Standard_DS13_V2 |
   Set-AzVMOperatingSystem -Windows -ComputerName $VMName -Credential $Cred -ProvisionVMAgent -EnableAutoUpdate |
   Set-AzVMSourceImage -PublisherName "MicrosoftSQLServer" -Offer "SQL2017-WS2016" -Skus "SQLDEV" -Version "latest" |
   Add-AzVMNetworkInterface -Id $Interface.Id

# Create the VM
New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VMConfig


# Get the existing compute VM
$vm = Get-AzVM -Name <vm_name> -ResourceGroupName <resource_group_name>
        
# Register SQL VM with 'Lightweight' SQL IaaS agent
New-AzSqlVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -Location $vm.Location `
  -LicenseType PAYG -SqlManagementType LightWeight



# Get the existing Compute VM
$vm = Get-AzVM -Name <vm_name> -ResourceGroupName <resource_group_name>
      
# Register with SQL VM resource provider in full mode
Update-AzSqlVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName -SqlManagementType Full


Get-AzPublicIpAddress -ResourceGroupName $ResourceGroupName | Select IpAddress


Log into VM

mstsc /v:0.0.0.0.0




Stop-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName
