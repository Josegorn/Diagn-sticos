# Cambia el código de página a UTF-8 
$PSDefaultParameterValues["*:Encoding"] = "utf8";

Function mostrar_menu {
    # Título de la ventana
    $Host.UI.RawUI.WindowTitle = "Diagnóstico";
    # Menú
    Clear-Host;
    Write-Host ("");
    Write-Host ("Opciones:") -ForegroundColor "DarkYellow";
    Write-Host ("");
    Write-Host (" 1.") -ForegroundColor "DarkYellow" -NoNewline; 
        Write-Host (" Comprobar si todos los procesos erróneos han marcado la imagen como dañada") -ForegroundColor "White" -NoNewline;
        Write-Host (" (CheckHealth)") -ForegroundColor "DarkMagenta";
    Write-Host (" 2.") -ForegroundColor "DarkYellow" -NoNewline; 
        Write-Host (" Detectar si el almacén de componentes esté dañado                         ") -ForegroundColor "White" -NoNewline;
        Write-Host (" (ScanHealth)") -ForegroundColor "DarkMagenta";
    Write-Host (" 3.") -ForegroundColor "DarkYellow" -NoNewline; 
        Write-Host (" Detectar y reparar si el almacén de componentes esté dañado               ") -ForegroundColor "White" -NoNewline;
        Write-Host (" (RestoreHealth)") -ForegroundColor "DarkMagenta";
    Write-Host (" 4.") -ForegroundColor "DarkYellow" -NoNewline; 
        Write-Host (" Crear un informe del almacén de componentes de WinSxS                     ") -ForegroundColor "White" -NoNewline;
        Write-Host (" (AnalyzeComponentStore)") -ForegroundColor "DarkMagenta";
    Write-Host (" 5.") -ForegroundColor "DarkYellow" -NoNewline; 
        Write-Host (" Limpiar los componentes reemplazados del almacén de componentes           ") -ForegroundColor "White" -NoNewline;
        Write-Host (" (StartComponentCleanup)") -ForegroundColor "DarkMagenta";
    Write-Host (" 6.") -ForegroundColor "DarkYellow" -NoNewline; 
        Write-Host (" Examina y repara la integridad de todos los archivos de sistema           menu") -ForegroundColor "White" -NoNewline;
        Write-Host (" (SFC)") -ForegroundColor "DarkMagenta";
    Write-Host (" 7.") -ForegroundColor "DarkYellow" -NoNewline;
        Write-Host (" Realizar todos los diagnósticos") -ForegroundColor "DarkGreen" -NoNewline;
        Write-Host ("");
    Write-Host (" 0.") -ForegroundColor "DarkRed" -NoNewline;
        Write-Host (" Salir.") -ForegroundColor "White" -NoNewline;

}
mostrar_menu

while (( $opt = Read-Host -Prompt "Option: ") -ne "4"){

    Switch($opt)
    {
        1 {
            $Host.UI.RawUI.WindowTitle = "Check Health";
            Write-Host ("Check Health: ") -ForegroundColor "DarkRed" -NoNewline;
            Write-Host ("Se está realizando un diagnostico rápido de la imagen del sistema para ver si está dañada. No realiza ninguna reparación.") -ForegroundColor "White";
            Repair-WindowsImage -Online -CheckHealth -NoRestart;
            Write-Host ("Comprobación terminada.") -ForegroundColor "DarkGreen";
            Break;
        }
        2 {
            $Host.UI.RawUI.WindowTitle = "Scan Health";
            Write-Host ("Scan Health: ") -ForegroundColor "DarkRed" -NoNewline;
            Write-Host ("Se está realizando un diagnostico exhaustivo de la imagen del sistema para ver si está dañada. No realiza ninguna reparación.") -ForegroundColor "White";
            Repair-WindowsImage -Online -ScanHealth -NoRestart;
            Write-Host ("Comprobación terminada.") -ForegroundColor "DarkGreen";
            Break;
        }
        3 {
            $Host.UI.RawUI.WindowTitle = "Restore Health";
            Write-Host ("Restore Health: ") -ForegroundColor "DarkRed" -NoNewline;
            Write-Host ("Se está realizando un diagnostico exhaustivo de la imagen del sistema y se realizarán operaciones de repararión si encuentra errores..") -ForegroundColor "White";
            Repair-WindowsImage -Online -RestoreHealth; 
            Write-Host ("Comprobación terminada.") -ForegroundColor "DarkGreen";
            Break;
        }
        4 {
            $Host.UI.RawUI.WindowTitle = "Analyze Component Store";
            Write-Host ("Analyze Component Store: ") -ForegroundColor "DarkRed" -NoNewline;
            Write-Host ("Se está realizando un anñalisis el almacen de componentes WinSxS que contiene los archivos necesarios para actualizaciones, configuraciones, y componentes del sistema.") -ForegroundColor "White";
            Get-WindowsReservedStorageState -Online -NoRestart;
            Write-Host ("Comprobación terminada.") -ForegroundColor "DarkGreen";
            Break;
        }
        5 {
            $Host.UI.RawUI.WindowTitle = "Start Component Cleanup";
            Write-Host ("Start Component Cleanup: ") -ForegroundColor "DarkRed" -NoNewline;
            Write-Host ("Se está limpiando el almacen de componentes WinSxS y para liberar espacio en disco y eliminando archivos innecesarios y obsoletos.") -ForegroundColor "White";
            Repair-WindowsImage -Online -StartComponentCleanup -NoRestart; -ResetBase -RasetApps;
            Optimize-AppXProvisionedPackages -Online -CleanupTemporaryFiles  -NoRestart;
            Write-Host ("Comprobación terminada.") -ForegroundColor "DarkGreen";
            Break;
        }
        6 {
            $Host.UI.RawUI.WindowTitle = "Start Component Cleanup";
            Write-Host ("Start Component Cleanup: ") -ForegroundColor "DarkRed" -NoNewline;
            Write-Host ("Se está limpiando el almacen de componentes WinSxS y para liberar espacio en disco y eliminando archivos innecesarios y obsoletos.") -ForegroundColor "White";
            Start-Process -FilePath "C:\Windows\System32\sfc.exe" -ArgumentList '/scannow' -Wait -Verb RunAs;
            Write-Host ("Comprobación terminada.") -ForegroundColor "DarkGreen";
            Break;
        }
        7 {
            $Host.UI.RawUI.WindowTitle = "Analisis completo";
            Write-Host ("Se procederá a realizar todos los diagosticos.") -ForegroundColor "White";
            Repair-WindowsImage -Online -RestoreHealth; 
            Repair-WindowsImage -Online -StartComponentCleanup -NoRestart; -ResetBase -RasetApps;
            Start-Process -FilePath "C:\Windows\System32\sfc.exe" -ArgumentList '/scannow' -Wait -Verb RunAs;
            Write-Host ("Comprobación terminada.") -ForegroundColor "DarkGreen";
            Break;
        }
        default {
            return 0
        }                              
    }
    mostrar_menu
}