$PSDefaultParameterValues["*:Encoding"] = "utf8";

get-item 


Write-Information -MessageData Comprobando el estado del sistema...
Repair-WindowsImage -Online -CheckHealth -NoRestart
Write-Information -MessageData Comprobando los componentes del sistema...
Repair-WindowsImage -Online -ScanHealth -NoRestart
Write-Information -MessageData Restaurando los componentes del sistema...
Repair-WindowsImage -Online -RestoreHealth -NoRestart
Write-Information -MessageData Comprobando el almacen de componentes appx...
Get-WindowsReservedStorageState
Write-Information -MessageData Limpiando el almacen de componenetes appx...
Optimize-AppXProvisionedPackages -Online


