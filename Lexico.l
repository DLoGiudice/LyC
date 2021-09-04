/* Sección Definiciones: INCLUDES - DEFINES - VAR GLOBALES */
%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include <float.h>

#include "y.tab.h"
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

TIPO_FLOAT      "FLOAT"
TIPO_INT        "INT"
TIPO_STRING	    "STRING"

DISPLAY	        "DISPLAY"
GET		        "GET"

DIM		        "DIM"
AS		        "AS"

AND		        "AND"
OR 		        "OR"
NOT		        "NOT"


/* Sección REGLAS: Patrones necesarios para analisis lexico */
%%
"DIM"           return DIM;
%%
