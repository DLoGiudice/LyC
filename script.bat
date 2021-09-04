@echo off
C:\GnuWin32\bin\bison Sintactico.y
echo "generando archivo bison.."
C:\GnuWin32\bin\flex Lexico.l
echo "generando archivo flex.."
pause
C:\MinGW\bin\gcc.exe sintactico.tab.c lex.yy.c -o Compilado.exe
echo "compilando el archivo flex..se crea el compilado.exe"
pause
Compilado.exe tests/pruebas.txt
echo "analizador lexico sobre pruebas.txt"
del lex.yy.C
del Compilado.exe
echo "se borran archivos demas.."
pause