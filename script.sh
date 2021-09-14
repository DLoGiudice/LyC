bison -dyv sintactico.y
flex Lexico.l
gcc y.tab.c lex.yy.c -o primera_entrega.exe
cat pruebas_simples.txt | ./primera_entrega.exe
rm -f sintactico.tab.c
#rm -f y.output
rm -f y.tab.h
rm -f y.tab.c
rm -f lex.yy.c
