@echo off

:: Cambia el c¢digo de p gina a 850 (ANSI Europa Occidental)
chcp 850 > null
:: Activar el uso de variables locales
setlocal

:: Colores
set BLANCO=[0m
set ROJO=[91m
set VERDE=[92m
set AMARILLO=[93m
set VIOLETA=[95m

title Diagn¢sticos

cls
echo.
echo %AMARILLO%Opciones:%BLANCO%
echo.
echo %AMARILLO%1.%BLANCO% Comprobar si alg£n proceso err¢neo ha marcado la imagen como da¤ada  %VIOLETA%(/CheckHealth)%BLANCO%
echo %AMARILLO%2.%BLANCO% Detectar si el almac‚n de componentes est‚ da¤ado                    %VIOLETA%(/ScanHealth)%BLANCO%
echo %AMARILLO%3.%BLANCO% Detectar y reparar si el almac‚n de componentes est‚ da¤ado          %VIOLETA%(/RestoreHealth)%BLANCO%
echo %AMARILLO%4.%BLANCO% Crear un informe del almac‚n de componentes de WinSxS                %VIOLETA%(/AnalyzeComponentStore)%BLANCO%
echo %AMARILLO%5.%BLANCO% Limpiar los componentes reemplazados del almac‚n de componentes      %VIOLETA%(/StartComponentCleanup)%BLANCO%
echo %AMARILLO%6.%BLANCO% Examina y repara la integridad de todos los archivos de sistema      %ROJO%(SFC /ScanNow)%BLANCO%
echo %AMARILLO%7.%VERDE% Realizar todos los diagn¢sticos%BLANCO%  
echo.
echo %ROJO%0.%BLANCO% Salir
echo.
choice /C:12345670 /n /t 20 /d 0 /m "Opci¢n: "

goto :FUNCION_%errorlevel% 

:FUNCION_1
    title Check Health
    echo %ROJO%Check Health:%BLANCO% Se est  realizando un diagnostico r pido de la imagen del sistema para ver si est  da¤ada. No realiza ninguna reparaci¢n.
    echo %ROJO%
    dism /Online /CleanUp-Image /CheckHealth 1>nul 2>&1
    echo %VERDE%Comprobaci¢n terminada.%BLANCO%
    endlocal & pause & exit /B 0 

:FUNCION_2
    title Scan Health
    echo %ROJO%Scan Health:%BLANCO% Se est  realizando un diagnostico exhaustivo de la imagen del sistema para ver si est  da¤ada. No realiza ninguna reparaci¢n.
    echo %ROJO%
    dism /Online /CleanUp-Image /ScanHealth 1>nul  2>&1
    echo %VERDE%Comprobaci¢n terminada.%BLANCO%
    endlocal & pause & exit /B 0 

:FUNCION_3
    title Restore Health
    echo %ROJO%Restore Health:%BLANCO% Se est  realizando un diagnostico exhaustivo de la imagen del sistema y se realizar n operaciones de reparari¢n si encuentra errores.
    echo %ROJO%
    dism /Online /CleanUp-Image /RestoreHealth 1>nul 2>&1
    echo %VERDE%Comprobaci¢n terminada.%BLANCO%
    endlocal & pause & exit /B 0  

:FUNCION_4
    title Analyze Component Store
    echo %ROJO%Analyze Component Store:%BLANCO% Se est  realizando un an¤alisis el almacen de componentes WinSxS que contiene los archivos necesarios para actualizaciones, configuraciones, y componentes del sistema.
    echo %ROJO%
    dism /Online /CleanUp-Image /AnalyzeComponentStore 1>nul 2>&1
    echo %VERDE%Comprobaci¢n terminada.%BLANCO%
    endlocal & pause & exit /B 0 

:FUNCION_5
    title Start Component Cleanup
    echo %ROJO%Start Component Cleanup:%BLANCO% Se est  limpiando el almacen de componentes WinSxS y para liberar espacio en disco y eliminando archivos innecesarios y obsoletos.
    echo %ROJO%
    dism /Online /CleanUp-Image /StartComponentCleanup /ResetBase 1>nul 2>&1
    echo %VERDE%Comprobaci¢n terminada.%BLANCO%
    endlocal & pause & exit /B 0 

:FUNCION_6
    title System File Checker
    echo %ROJO%System File Checker:%BLANCO% Se est  realizando un diagnostico completo de todos los archivos protegidos de Windows.Se realizar n operaciones de reparari¢n si encuentra errores.
    echo %ROJO%
    sfc /scannow 1>nul 2>&1
    echo %VERDE%Comprobaci¢n terminada.%BLANCO%
    endlocal & pause & exit /B 0 

:FUNCION_7
    title Analisis completo
    echo Se proceder  a realizar todos los diagosticos.
    dism /Online /CleanUp-Image /Checkhhealth 1>nul 2>&1
    echo %ROJO%Restore Health.%BLANCO%
    dism /Online /CleanUp-Image /RestoreHealth 1>nul 2>&1
    if not ERRORLEVEL 0 echo %AMARILLO%Se han encontrado errores.%BLANCO% & pause & exit /B 1
    echo %ROJO%Start Component Cleanup.%BLANCO% 
    dism /Online /CleanUp-Image /StartComponentCleanup /ResetBase 1>nul 2>&1
    if not ERRORLEVEL 0 echo %AMARILLO%Se han encontrado errores.%BLANCO% & pause & exit 1 /B
    echo %ROJO%System File Checker.%BLANCO%
    sfc /scannow 1>nul 2>&1
    if not ERRORLEVEL 0 echo %AMARILLO%Se han encontrado errores.%BLANCO% & pause & exit /B 1 
    echo %VERDE%Comprobaci¢n terminada.%BLANCO%
    endlocal & pause & exit /B 0 

:FUNCION_8
    endlocal & exit 0 