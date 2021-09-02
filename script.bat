@echo off
C:\GnuWin32\bin\flex ejemplo2.l
echo "generando archivo flex.."
pause
C:\MinGW\bin\gcc.exe lex.yy.c -o Compilado.exe
echo "compilando el archivo flex..se crea el compilado.exe"
pause
Compilado.exe prueba1.txt
echo "analizador lexico sobre prueba1.txt"
del lex.yy.C
del Compilado.exe
echo "se borran archivos demas.."
pause