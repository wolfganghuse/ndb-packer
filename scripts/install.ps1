# Add Registry Key to regiser connection-specific domain suffix

$RegistryPath = 'HKLM:\Software\Policies\Microsoft\Windows NT\DNSClient'
$Name         = 'RegisterAdapterName'
$Value        = '1'
# Create the key if it does not exist
If (-NOT (Test-Path $RegistryPath)) {
  New-Item -Path $RegistryPath -Force | Out-Null
}  
# Now set the value
New-ItemProperty -Path $RegistryPath -Name $Name -Value $Value -PropertyType DWORD -Force 