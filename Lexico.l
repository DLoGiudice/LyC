/* Sección Definiciones: INCLUDES - DEFINES - VAR GLOBALES */
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <float.h>

#include "y.tab.h"

#define ENTERO_MAX 32767
#define ENTERO_MIN -32768

#define REAL_MAX 3.40282347e+38F
#define REAL_MIN -3.40282347e+38F

#define LIMITE 30

int validarEntero(int num);
int validarCadena(char *str);
int validarReal(float num);

%}

/* Sección conjuntos y Regex: Opciones - Conjuntos - Expresiones regulares */
/* Esto indica a FLEX que lea solo fichero de entrada */
%option noyywrap
/* Nos permite obtener el numero de linea*/
%option yylineno

DIGITO          [0-9]
LETRA           [a-zA-Z]

REAL     	    -?{DIGITO}?+"."{DIGITO}*
ENTERO          -?{DIGITO}+
CADENA          \"(\\.|[^\"])*\"

GUIONES         ("-"|"_")
ID			    {LETRA}({LETRA}|{DIGITO}|{GUIONES})*

TIPO_REAL       "real"
TIPO_INTEGER    "integer"
TIPO_STRING	    "string"

COMEN_ABRE		"*/"
COMEN_CIERRA	"/*"
COMEN_CADENA	[^\*\/\n\r]*
COMENTARIO		{COMEN_ABRE}{COMEN_CADENA}{COMEN_CIERRA}
COMENTARIO_ANI  {COMEN_ABRE}({COMEN_CADENA}|{COMENTARIO})+{COMEN_CIERRA}

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

{TIPO_REAL}     printf ("TIPO_REAL %s", yytext); return TIPO_REAL;
{TIPO_INTEGER}  return TIPO_INTEGER;
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

"LONG"          return LONG;
"EQUMAX"        return EQUMAX;
"EQUMIN"        return EQUMIN;

{ID}            { yylval.value_string = strdup(yytext);
				  validarCadena(yylval.value_string);
				  return ID; }

{CADENA}	    {	yylval.value_string = strdup(yytext); 
                	validarCadena(yylval.value_string);
					int longitud = strlen(yylval.value_string);
					char cte_string[longitud];
					strcpy(cte_string, "");
					strcat(cte_string, yytext+1);
					strcpy(cte_string + strlen(cte_string) - 1, "\0");
					strcpy(yylval.value_string, cte_string);
                    return CADENA; }

{REAL}		    { yylval.value_float = atof(yytext);
                    validarReal(yylval.value_float); 
                    return REAL; }
{ENTERO}		{   yylval.value_int = atoi(yytext); 
                    validarEntero(yylval.value_int); 
                    return ENTERO; }

{COMENTARIO}	 { printf("comentario"); }
{COMENTARIO_ANI} { printf("comentario ani"); }

"\n"
"\t"
" "	

%%

/* Validaciones Entero  */
int validarEntero(int num)
{
	if(num < ENTERO_MIN || num > ENTERO_MAX){
		printf("Constante ENTERO fuera de rango\n");
		fprintf(stderr, "Fin de programa\n");
		exit (1);
	}
	return 1;
}

/* Validaciones Cadena  */
int validarCadena(char *str)
{
	if(strlen(str) > LIMITE){
		printf("Constante CADENA o ID fuera de rango\n");
		fprintf(stderr, "Fin de programa\n");
		exit (1);
	}
	return 1;
}

/* Validaciones Real  */
int validarReal(float num)
{
	if(num < REAL_MIN || num > REAL_MAX){
		printf("Constante REAL fuera de rango\n");
		fprintf(stderr, "Fin de programa\n");
		exit (1);
	}
	return 1;
}
