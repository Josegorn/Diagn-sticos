# Cambia el código de página a UTF-8
[Console]::InputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
# Ejecutar comando CMD
Function ejecutar_cmd([string]$comando) {
    [System.Diagnostics.Process]$proceso = New-Object System.Diagnostics.Process;
    $proceso.StartInfo.FileName = $comando.Split(" ")[0];
    $proceso.StartInfo.Arguments = $comando.Split(" ", 2)[1];
    $proceso.StartInfo.RedirectStandardOutput = $true;
    $proceso.StartInfo.UseShellExecute = $false;
    $proceso.StartInfo.StandardOutputEncoding = [System.Text.Encoding]::GetEncoding("cp850");

    $proceso.Start() | Out-Null;
    While (!$proceso.StandardOutput.EndOfStream) {
        Write-Output $proceso.StandardOutput.ReadLine();
    }
    $proceso.WaitForExit();
} 
# Tabla de Opciones
$tabla_opciones = @(
    [PSCustomObject]@{
                        Op = "1";
                        Comando = "Repair-WindowsImage -Online -CheckHealth -NoRestart | Format-List -Property ImageHealthState";
                        Nombre = "Check Health";
                        Color_Nombre = "DarkMagenta";             
                        Descrip = "Comprobar si todos los procesos erróneos han marcado la imagen como dañada.";
                        Color_Descrip = "White";
                        Texto_Ejec = "Se está realizando un diagnostico rapidez de la imagen del sistema para ver si está dañada. No realiza ninguna reparación.";
                    };
    [PSCustomObject]@{
                        Op = "2";
                        Comando = "Repair-WindowsImage -Online -ScanHealth -NoRestart | Format-List -Property ImageHealthState";
                        Nombre = "Scan Health";
                        Color_Nombre = "DarkMagenta";     
                        Descrip = "Detectar si el almacén de componentes esté dañado.";
                        Color_Descrip = "White";
                        Texto_Ejec = "Se está realizando un diagnostico exhaustivo de la imagen del sistema para ver si está dañada. No realiza ninguna reparación.";
                    };
    [PSCustomObject]@{  
                        Op = "3";
                        Comando = "Repair-WindowsImage -Online -RestoreHealth -NoRestart | Format-List -Property ImageHealthState";
                        Nombre = "Restore Health";
                        Color_Nombre = "DarkMagenta";
                        Descrip = "Detectar y reparar si el almacén de componentes esté dañado.";
                        Color_Descrip = "White";
                        Texto_Ejec = "Se está realizando un diagnostico exhaustivo de la imagen del sistema y se realizarán operaciones de repararión si encuentra errores.";
                    };
    [PSCustomObject]@{
                        Op = "4";
                        Comando = "ejecutar_cmd('C:\Windows\System32\dism.exe /Online /Cleanup-Image /AnalyzeComponentStore') | Select-String 'Tamaño','Número','Se recomienda' -SimpleMatch";
                        Nombre = "Analyze Component Store";
                        Color_Nombre = "DarkMagenta";
                        Descrip = "Crear un informe del almacén de componentes de WinSxS.";
                        Color_Descrip = "White";
                        Texto_Ejec = "Se está realizando un análisis el almacen de componentes WinSxS que contiene los archivos necesarios para actualizaciones, configuraciones, y componentes del sistema.";    
                    };
    [PSCustomObject]@{  
                        Op = "5";
                        Comando = "ejecutar_cmd('C:\Windows\System32\dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase') | Out-Null";
                        Nombre = "Start Component Cleanup";
                        Color_Nombre = "DarkMagenta";
                        Descrip = "Limpiar los componentes reemplazados del almacén de componentes.";
                        Color_Descrip = "White";
                        Texto_Ejec = "Se está limpiando el almacen de componentes WinSxS y para liberar espacio en disco y eliminando archivos innecesarios y obsoletos.";
                    };
    [PSCustomObject]@{  
                        Op = "6";
                        Comando = "ejecutar_cmd('C:\Windows\System32\sfc.exe /scannow') | Out-Null";
                        Nombre = "System File Checker";
                        Color_Nombre = "DarkRed";
                        Descrip = "Examina y repara la integridad de todos los archivos de sistema.";
                        Color_Descrip = "White";
                        Texto_Ejec = "Se está realizando un diagnostico completo de todos los archivos protegidos de Windows.Se realizarán operaciones de repararión si encuentra errores.";
                    };
    [PSCustomObject]@{
                        Op = "7";
                        Comando = "Repair-WindowsImage -Online -RestoreHealth -NoRestart | Format-List -Property ImageHealthState; ejecutar_cmd('C:\Windows\System32\dism.exe /Online /Cleanup-Image /StartComponentCleanup /ResetBase') | Out-Null; ejecutar_cmd('C:\Windows\System32\sfc.exe /scannow') | Out-Null"; 
                        Nombre = "Análisis completo";
                        Color_Nombre = $null;
                        Descrip = "Realizar todos los diagnósticos.";
                        Color_Descrip = "DarkGreen";
                        Texto_Ejec = "Se procederá a realizar todos los diagosticos.";
                    };
    [PSCustomObject]@{
                        Op = "0";
                        Descrip = "Salir.";
                        Color_Descrip = "White";
                    };
)

# Función para mostrar el menú
Function mostrar_menu {
    # Título de la ventana
    $Host.UI.RawUI.WindowTitle = "Diagnóstico";
    # Título de menú
    Write-Host ("");
    Write-Host ("Opciones:") -ForegroundColor "DarkYellow";
    Write-Host ("");
    # Opciones del 1 al 7
    for ([int]$i = 0; $i -lt 7; $i++) {
        Write-Host ($tabla_opciones[$i].Op+". ") -ForegroundColor "DarkYellow" -NoNewline;
        Write-Host ($tabla_opciones[$i].Descrip) -ForegroundColor $tabla_opciones[$i].Color_Descrip -NoNewline;
        # Ajustar la tabulación de la columna
        if ($tabla_opciones[$i].Color_Nombre) {
            Write-Host (" " * (80 - $tabla_opciones[$i].Descrip.Length)) -NoNewline;
            Write-Host ($tabla_opciones[$i].Nombre) -ForegroundColor $tabla_opciones[$i].Color_Nombre;
        }
        else {
            write-host ("");
        }
    }
    Write-Host ("");
    # Opción Salir
    Write-Host ($tabla_opciones[7].Op+". ") -ForegroundColor "DarkRed" -NoNewline;
    Write-Host ($tabla_opciones[7].Descrip) -ForegroundColor $tabla_opciones[7].Color_Descrip;
    Write-Host ("");
}
Clear-Host;
mostrar_menu;

Write-Host ("Opción: ") -NoNewline;
# Bucle para mostrar el menú
while ( ($opt = [Console]::ReadKey($true) ).KeyChar -ne "0") {
  
    # Convertir la tecla pulsada a un número
    [int]$indice = [int]($opt.KeyChar.toString()) - 1;
    # Comprobar si la opción es un número
    if ($opt.KeyChar -match "^[0-7]$") {
        Clear-Host;
        $Host.UI.RawUI.WindowTitle = $tabla_opciones[$indice].Nombre;
        Write-Host ($tabla_opciones[$indice].Nombre+": ") -ForegroundColor "DarkRed" -NoNewline;
        Write-Host ($tabla_opciones[$indice].Texto_Ejec) -ForegroundColor "White";
        Invoke-Expression -Command $tabla_opciones[$indice].Comando;
        Write-Host ("Comprobación terminada.") -ForegroundColor "DarkGreen";
        Write-Host ("");
        pause;

    }
    Clear-Host;
    mostrar_menu
    Write-Host ("Opción: ") -NoNewline;        
}
 
