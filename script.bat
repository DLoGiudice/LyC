@echo off
echo "generando archivo bison.."
C:\GnuWin32\bin\bison -dyv sintactico.y
echo "generando archivo flex.."
C:\GnuWin32\bin\flex Lexico.l
echo "compilando el archivo flex..se crea el compilado.exe"
C:\MinGW\bin\gcc.exe y.tab.c lex.yy.c -o Segunda.exe
echo "analizador lexico sobre pruebas.txt"
type pruebas.txt | Segunda.exe
echo "se borran archivos demas.."
del y.tab.c
del y.tab.h
del y.output
del lex.yy.C
pause