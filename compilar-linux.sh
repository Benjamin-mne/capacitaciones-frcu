#!/bin/bash
clear

mkdir -p bin

echo "=========================================="
echo "       COMPILANDO UNITS..."
echo "=========================================="

echo "=============== MODEL ==============="
echo "Compilando Capacitacion.pas..."
fpc src/model/Capacitacion.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar Capacitacion.pas"
    exit 1
fi

echo "Compilando Alumno.pas..."
fpc src/model/Alumno.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar Alumno.pas"
    exit 1
fi

echo "Compilando Inscripcion.pas..."
fpc src/model/Inscripcion.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar Inscripcion.pas"
    exit 1
fi

echo "-------------- ARBOLES --------------"
echo "Compilando AVL.pas..."
fpc src/model/AVL.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar AVL.pas"
    exit 1
fi

echo "=============== UTILS ==============="
echo "Compilando DAOUtils.pas..."
fpc src/utils/DAOUtils.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar DAOUtils.pas"
    exit 1
fi

echo "Compilando ViewUtils.pas..."
fpc src/utils/ViewUtils.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar ViewUtils.pas"
    exit 1
fi

echo "=============== DAO ==============="
echo "Compilando DAOAlumno.pas..."
fpc src/dao/DAOAlumno.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar DAOAlumno.pas"
    exit 1
fi

echo "Compilando DAOCapacitacion.pas..."
fpc src/dao/DAOCapacitacion.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar DAOCapacitacion.pas"
    exit 1
fi

echo "============ CONTROLLER ============"
echo "Compilando ControllerAlumno.pas..."
fpc src/controller/ControllerAlumno.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar ControllerAlumno.pas"
    exit 1
fi

echo "Compilando ControllerCapacitacion.pas..."
fpc src/controller/ControllerCapacitacion.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar ControllerCapacitacion.pas"
    exit 1
fi

echo "=============== VIEW ==============="
echo "Compilando AlumnosView.pas..."
fpc src/view/AlumnosView.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar AlumnosView.pas"
    exit 1
fi

echo "Compilando CapacitacionesView.pas..."
fpc src/view/CapacitacionesView.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar CapacitacionesView.pas"
    exit 1
fi

echo "Compilando Menu.pas..."
fpc src/view/Menu.pas -FUbin
if [ $? -ne 0 ]; then
    echo "ERROR al compilar Menu.pas"
    exit 1
fi

echo "=========================================="
echo "     COMPILANDO PROGRAMA PRINCIPAL..."
echo "=========================================="
fpc src/main.pas -FErbin -obin/FRCU-capacitaciones
if [ $? -ne 0 ]; then
    echo "=========================================="
    echo "   ERROR: La compilación ha fallado."
    echo "=========================================="
    exit 1
fi

echo "=========================================="
echo "  El programa se ha compilado correctamente."
echo "  Puedes ejecutarlo con: ./bin/FRCU-capacitaciones"
echo "=========================================="

echo "=========================================="
echo "     LIMPIANDO ARCHIVOS TEMPORALES..."
echo "=========================================="
rm -f bin/*.o bin/*.ppu

exit 0
