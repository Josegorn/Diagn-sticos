# Cambia el código de página a UTF-8 
$PSDefaultParameterValues["*:Encoding"] = "utf8";

# Definir algunos alias 
Function PrintInf{ Param([string] $msg = "", [consolecolor] $Color="White", [boolean] $NoNewline = "false"); Write-Information -MessageData $msg -ForegroundColor $color -NoNewline $NoNewline;}

# Título de la ventana
$Host.UI.RawUI.WindowTitle = "Diagnóstico";

PrintInf("");
PrintInf("Opciones:", "LightYellow", "false");
PrintInf("");
PrintInf(" 1.", "LightYellow", "true"); PrintInf("Comprobar si algún proceso erróneo ha marcado la imagen como dañada"+"\t", "White","true"); PrintInf("\(CheckHealth\)", "Violet", "false");
PrintInf(" 2. Comprobar los componentes del sistema");
PrintInf(" 3. Restaurar los componentes del sistema");
PrintInf(" 4. Comprobar el almacen de componentes appx");
PrintInf(" 5. Limpiar el almacen de componentes appx");
PrintInf("");

#Write-Information -MessageData Comprobando el estado del sistema...
#Repair-WindowsImage -Online -CheckHealth -NoRestart
#Write-Information -MessageData Comprobando los componentes del sistema...
#Repair-WindowsImage -Online -ScanHealth -NoRestart
#Write-Information -MessageData Restaurando los componentes del sistema...
#Repair-WindowsImage -Online -RestoreHealth -NoRestart
#Write-Information -MessageData Comprobando el almacen de componentes appx...
#Get-WindowsReservedStorageState
#Write-Information -MessageData Limpiando el almacen de componenetes appx...
#Optimize-AppXProvisionedPackages -Online


