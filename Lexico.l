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

GUIONES         [-_]
ID			    {LETRA}({LETRA}|{DIGITO}|{GUIONES})*

_WHILE		    "WHILE"|"while"|"While"

_IF		        "IF"|"if"|"If"
_ELSE		    "ELSE"|"else"|"Else"

_FLOAT		    "FLOAT"|"float"|"Float"
_INT    	    "INT"|"int"|"Int"
_STRING	        "STRING"|"string"|"String"

_DISPLAY	    "DISPLAY"|"display"|"Display"
_GET		    "GET"|"get"|"Get"

_DIM		    "DIM"|"dim"|"Dim"
_AS		        "AS"|"As"|"as"

_AND		    "AND"|"and"|"And"
_OR 		    "OR"|"or"|"Or"
_NOT		    "NOT"|"not"|"Not"




/* Sección REGLAS: Patrones necesarios para analisis lexico */
%%
":="		    { return OP_ASIG;}
"+"				{ return OP_MAS;}
"-"				{ return OP_MENOS;}
"*"				{ return OP_MUL;}
"/"				{ return OP_DIV;}

","         	{ return COMA;}
";"         	{ return PUNTO_COMA;}

">"         	{ return OP_MAY;}
"<"         	{ return OP_MEN;}
">="        	{ return OP_MAY_IGUAL;}
"<="        	{ return OP_MEN_IGUAL;}
"=="       	 	{ return OP_IGUALIGUAL;}
"<>"        	{ return OP_DISTINTO;}

{_WHILE}       {return _WHILE;}
{_IF}          {return _IF;}
{_ELSE}        {return _ELSE;}
{_FLOAT}       {return _FLOAT;}
{_INTEGER}     {return _INTEGER;}
{_STRING}      {return _STRING;}
{_DISPLAY}     {return _PUT;}
{_GET}         {return _GET;}
{_DIM}         {return _DIM;}
{_AS}          {return _AS;}
{_AND}         {return _AND;}
{_OR}          {return _OR;}
{_NOT}         {return _NOT;}



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

