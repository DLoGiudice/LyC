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
CADENA          \"(\\.|[^\"])*\"

GUIONES         ("-"|"_")
ID			    {LETRA}({LETRA}|{DIGITO}|{GUIONES})*

TIPO_FLOAT      "float"
TIPO_INT        "int"
TIPO_STRING	    "string"

/*\* este es un comentario \* Comentario anidado *\ SI *\ */

/* Sección REGLAS: Patrones necesarios para analisis lexico */
%%
":="		    return OP_ASIG;
"+"				return OP_MAS;
"-"				return OP_MENOS;
"*"				return OP_MUL;
"/"				return OP_DIV;

","         	return COMA;
";"         	return PUNTO_COMA;
"["         	return CORCHETE_ABRE;
"]"         	return CORCHETE_CIERRA;
"("         	return PARENTESIS_ABRE;
")"         	return PARENTESIS_CIERRA;
"{"         	return LLAVE_ABRE;
"}"         	return LLAVE_CIERRA;

">"         	return OP_MAY;
"<"         	return OP_MEN;
">="        	return OP_MAY_IGUAL;
"<="        	return OP_MEN_IGUAL;
"=="       	 	return OP_IGUALIGUAL;
"<>"        	return OP_DISTINTO;

{TIPO_FLOAT}    return TIPO_FLOAT;
{TIPO_INT}      return TIPO_INT;
{TIPO_STRING}   return TIPO_STRING;

"WHILE"         return WHILE;
"IF"            return IF;
"ELSE"          return ELSE;
"DISPLAY"       return DISPLAY;
"GET"           return GET;
"DIM"           return DIM;
"AS"            return AS;
"AND"           return AND;
"OR"            return OR;
"NOT"           return NOT;

{CADENA}        return CADENA;
{REAL}          return REAL;
{ENTERO}        return ENTERO;
%%
