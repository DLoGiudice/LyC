/* Sección Definiciones: INCLUDES - DEFINES - VAR GLOBALES */
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include <float.h>

FILE *yyin;

%}

/* Sección conjuntos y Regex: Opciones - Conjuntos - Expresiones regulares */
/* Esto indica a FLEX que lea solo fichero de entrada */
%option noyywrap
/* Nos permite obtener el numero de linea*/
%option yylineno

DIGITO          [0-9]
LETRA           [a-zA-Z]

CHAR_PUNTO      ["."]
REAL     	    {DIGITO}{0,8}{CHAR_PUNTO}{DIGITO}{1,8}
ENTERO          {DIGITO}+
CADENA          \"[^\n"]*\"

GUIONES         ("-"|"_")
ID			    {LETRA}({LETRA}|{DIGITO}|{GUIONES})*

WHILE		    "WHILE"

IF		        "IF"
ELSE		    "ELSE"

FLOAT		    "FLOAT"
INT    	        "INT"
STRING	        "STRING"

DISPLAY	        "DISPLAY"
GET		        "GET"

DIM		        "DIM"
AS		        "AS"

AND		        "AND"
OR 		        "OR"
NOT		        "NOT"




/* Sección REGLAS: Patrones necesarios para analisis lexico */
%%
":="		    { return OP_ASIG;}
"+"				{ return OP_MAS;}
"-"				{ return OP_MENOS;}
"*"				{ return OP_MUL;}
"/"				{ return OP_DIV;}

","         	{ return COMA;}
";"         	{ return PUNTO_COMA;}
"["         	{ return CORCHETE_ABRE;}
"]"         	{ return CORCHETE_CIERRA;}
"("         	{ return PARENTESIS_ABRE;}
")"         	{ return PARENTESIS_CIERRA;}

">"         	{ return OP_MAY;}
"<"         	{ return OP_MEN;}
">="        	{ return OP_MAY_IGUAL;}
"<="        	{ return OP_MEN_IGUAL;}
"=="       	 	{ return OP_IGUALIGUAL;}
"<>"        	{ return OP_DISTINTO;}

{WHILE}         { return WHILE; }
{IF}            { return IF; }
{ELSE}          { return ELSE; }
{FLOAT}         { return FLOAT; }
{DISPLAY}       { return PUT; }
{GET}           { return GET; }
{DIM}           { return DIM; }
{AS}            { return AS; }
{AND}           { return AND; }
{OR}            { return OR; }
{NOT}           { return NOT; }
{STRING}        { return STRING; }
{REAL}          { return REAL; }
{INTEGER}       { return INTEGER; }



%%
/* Sección CODIGO: Patrones necesarios para analisis lexico */
int main(int argc,char *argv[])
{
    if ((yyin = fopen(argv[1], "rt")) == NULL)
    {
        printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
    }
    else
    {
        yylex();
    }
fclose(yyin);
}

