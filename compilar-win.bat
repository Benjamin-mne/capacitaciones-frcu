@echo off
cls

REM
if not exist bin mkdir bin

echo ==========================================
echo        COMPILANDO UNITS...
echo ==========================================

echo Compilando Capacitacion.pas...
fpc src\model\Capacitacion.pas -FUbin
if errorlevel 1 goto Error

echo ==========================================
echo Compilando Alumno.pas...
fpc src\model\Alumno.pas -FUbin
if errorlevel 1 goto Error

echo ==========================================
echo Compilando DAOUtils.pas...
fpc src\utils\DAOUtils.pas -FUbin
if errorlevel 1 goto Error

echo ==========================================
echo Compilando DAOAlumno.pas...
fpc src\dao\DAOAlumno.pas -FUbin
if errorlevel 1 goto Error

echo ==========================================
echo Compilando DAOCapacitacion.pas...
fpc src\dao\DAOCapacitacion.pas -FUbin
if errorlevel 1 goto Error

echo ==========================================
echo        COMPILANDO PROGRAMA PRINCIPAL...
echo ==========================================
fpc src\main.pas -FEbin -obin\FRCU-capacitaciones.exe
if errorlevel 1 goto Error
echo.

echo ==========================================
echo  El programa se ha compilado correctamente.
echo  Puedes ejecutarlo con: bin\FRCU-capacitaciones.exe
echo ==========================================
goto LimpiarArchivos
echo.

:Error
color 4F
echo.
echo ==========================================
echo  ERROR: La compilacion ha fallado.
echo ==========================================
echo.
pause
goto LimpiarArchivos

:LimpiarArchivos
echo ==========================================
echo        LIMPIANDO ARCHIVOS TEMPORALES ...
echo ==========================================
del /q bin\*.o bin\*.ppu 2>nul
goto End
echo.

:End
echo.
pause
if errorlevel 1 exit /b 1 else exit /b 0