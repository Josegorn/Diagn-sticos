@echo off
chcp 850 > nul

:menu
title Diagn¢sticos CMD
cls
echo.
echo [93mOpciones:[0m
echo.
echo [93m1.[0m Comprobar si alg£n proceso err¢neo ha marcado la imagen como da¤ada    [95m(/CheckHealth)[0m 
echo [93m2.[0m Detectar si el almac‚n de componentes est‚ da¤ado                      [95m(/ScanHealth)[0m 
echo [93m3.[0m Detectar y reparar si el almac‚n de componentes est‚ da¤ado            [95m(/RestoreHealth)[0m 
echo [93m4.[0m Crear un informe del almac‚n de componentes de WinSxS                  [95m(/AnalyzeComponentStore)[0m
echo [93m5.[0m Limpiar los componentes reemplazados del almac‚n de componentes        [95m(/StartComponentCleanup)[0m
echo [93m6.[0m Examina y repara la integridad de todos los archivos de sistema        [91m(SFC /ScanNow)[0m
echo [93m7.[92m Realizar todos los diagn¢sticos[0m  
echo.
echo Presiona otra tecla para salir...
echo.

set /P opcion="Opci¢n (1-7):" 

if "%opcion%"=="1" (

    title DISM Check Health
    DISM /Online /CleanUp-Image /CheckHealth
    echo.
    pause
    goto menu 
)
if "%opcion%"=="2" (

    title DISM Scan Health
    DISM /Online /CleanUp-Image /ScanHealth
    echo.
    pause
    goto menu 
)
if "%opcion%"=="3" (

    title DISM Restore Health
    DISM /Online /CleanUp-Image /RestoreHealth
    echo.
    pause
    goto menu 
)
if "%opcion%"=="4" (

    title DISM Analyze Component Store
    DISM /Online /CleanUp-Image /AnalyzeComponentStore
    echo.
    pause
    goto menu 
)
if "%opcion%"=="5" (

    title DISM Start Component Cleanup
    DISM /Online /CleanUp-Image /StartComponentCleanup /ResetBase
    echo.
    pause
    goto menu 
)
if "%opcion%"=="6" (

    title Comprobar la integridad de los recursos del sistema
    SFC /ScanNow
    echo.
    pause
    goto menu 
)
if "%opcion%"=="7" (

    title DISM Check Health
    DISM /Online /CleanUp-Image /CheckHealth
    title DISM Scan Health
    DISM /Online /CleanUp-Image /ScanHealth
    title DISM Restore Health
    DISM /Online /CleanUp-Image /RestoreHealth
    title DISM DISM Analyze Component Store
    DISM /Online /CleanUp-Image /AnalyzeComponentStore
    title DISM Start Component Cleanup
    DISM /Online /CleanUp-Image /StartComponentCleanup /ResetBase
    title Comprobar de recursos
    SFC /ScanNow
    echo.
    pause
    goto menu 
)
exit /B 0