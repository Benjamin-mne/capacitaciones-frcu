@echo off
cls

REM Crear carpeta bin si no existe
if not exist bin mkdir bin

echo ==========================================
echo            COMPILANDO UNITS...
echo ==========================================

echo =============== MODEL ===============
echo Compilando Capacitacion.pas...
fpc src\model\Capacitacion.pas -FUbin
if errorlevel 1 goto Error

echo Compilando Alumno.pas...
fpc src\model\Alumno.pas -FUbin
if errorlevel 1 goto Error

echo Compilando Inscripcion.pas...
fpc src\model\Inscripcion.pas -FUbin
if errorlevel 1 goto Error

echo =============== UTILS ===============
echo Compilando AVL.pas...
fpc src\utils\AVL.pas -FUbin
if errorlevel 1 goto Error

echo Compilando List.pas...
fpc src\utils\List.pas -FUbin
if errorlevel 1 goto Error

echo Compilando DAOUtils.pas...
fpc src\utils\DAOUtils.pas -FUbin
if errorlevel 1 goto Error

echo Compilando Utils.pas...
fpc src\utils\Utils.pas -FUbin
if errorlevel 1 goto Error

echo Compilando ViewUtils.pas...
fpc src\utils\ViewUtils.pas -FUbin
if errorlevel 1 goto Error

echo =============== DAO ===============
echo Compilando DAOAlumno.pas...
fpc src\dao\DAOAlumno.pas -FUbin
if errorlevel 1 goto Error

echo Compilando DAOCapacitacion.pas...
fpc src\dao\DAOCapacitacion.pas -FUbin
if errorlevel 1 goto Error

echo Compilando DAOInscripcion.pas...
fpc src\dao\DAOInscripcion.pas -FUbin
if errorlevel 1 goto Error

echo =============== CONTEXTO ===============
echo Compilando Contexto.pas...
fpc src\context\Contexto.pas -FUbin
if errorlevel 1 goto Error

echo ============= CONTROLLER ==============
echo Compilando ControllerAlumno.pas...
fpc src\controller\ControllerAlumno.pas -FUbin
if errorlevel 1 goto Error

echo Compilando ControllerCapacitacion.pas...
fpc src\controller\ControllerCapacitacion.pas -FUbin
if errorlevel 1 goto Error

echo Compilando ControllerInscripcion.pas...
fpc src\controller\ControllerInscripcion.pas -FUbin
if errorlevel 1 goto Error

echo =============== VIEW ===============
echo Compilando AlumnosView.pas...
fpc src\view\AlumnosView.pas -FUbin
if errorlevel 1 goto Error

echo Compilando CapacitacionesView.pas...
fpc src\view\CapacitacionesView.pas -FUbin
if errorlevel 1 goto Error

echo Compilando InscripcionesView.pas...
fpc src\view\InscripcionesView.pas -FUbin
if errorlevel 1 goto Error

echo Compilando ConsultasView.pas...
fpc src\view\ConsultasView.pas -FUbin
if errorlevel 1 goto Error

echo Compilando Menu.pas...
fpc src\view\Menu.pas -FUbin
if errorlevel 1 goto Error


echo ==========================================
echo      COMPILANDO PROGRAMA PRINCIPAL...
echo ==========================================
fpc src\main.pas -FEbin -obin\FRCU-capacitaciones.exe
if errorlevel 1 goto Error

echo ==========================================
echo  El programa se ha compilado correctamente.
echo  Ejecutalo con: bin\FRCU-capacitaciones.exe
echo ==========================================
goto LimpiarArchivos


:Error
color 4F
echo.
echo ==========================================
echo          ERROR: La compilacion fallo
echo ==========================================
echo.
pause
goto LimpiarArchivos


:LimpiarArchivos
echo ==========================================
echo      LIMPIANDO ARCHIVOS TEMPORALES...
echo ==========================================
del /q bin\*.o 2>nul
del /q bin\*.ppu 2>nul
goto End


:End
echo.
pause
exit /b 0
