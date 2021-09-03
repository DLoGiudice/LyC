@echo off
C:\GnuWin32\bin\flex ejemplo2.l
echo "generando archivo flex.."
pause
C:\MinGW\bin\gcc.exe lex.yy.c -o Compilado.exe
echo "compilando el archivo flex..se crea el compilado.exe"
pause
Compilado.exe tests/asignaciones.txt
echo "analizador lexico sobre asignaciones.txt"
Compilado.exe tests/operadores.txt
echo "analizador lexico sobre operadores.txt"
Compilado.exe tests/tipo_de_datos.txt
echo "analizador lexico sobre tipo_de_datos.txt"
del lex.yy.C
del Compilado.exe
echo "se borran archivos demas.."
pause