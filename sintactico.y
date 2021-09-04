%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>


int yyparse();
void yyerror(char const *str);
void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
}
%}

%union
{
    int value_int;  /* Para Enteros. */
    float value_float;  /* Para reales. */
    char* value_string;  /* Para strings. */
}

// Declaracion variables
%token OP_ASIG
%token OP_MAS
%token OP_MENOS
%token OP_MUL
%token OP_DIV

%token COMA
%token PUNTO_COMA
%token CORCHETE_ABRE
%token CORCHETE_CIERRA
%token PARENTESIS_ABRE
%token PARENTESIS_CIERRA
%token LLAVE_ABRE
%token LLAVE_CIERRA

%token OP_MAY
%token OP_MEN
%token OP_MAY_IGUAL
%token OP_MEN_IGUAL
%token OP_IGUALIGUAL
%token OP_DISTINTO

%token TIPO_FLOAT
%token TIPO_INT
%token TIPO_STRING

%token WHILE
%token IF
%token ELSE
%token DISPLAY
%token GET
%token DIM
%token AS
%token AND
%token OR
%token NOT

%token <value_int> ENTERO
%token <value_float> REAL
%token <value_string> CADENA

%%

programa: declaracion |
    programa declaracion |
    programa factor;

declaracion: DIM {
    printf("DECLARACION");
    };

factor: 
    ENTERO {
        printf("factor ENTERO");
    } |
    REAL {
        printf("factor REAL");
    } |
    CADENA {
        printf("factor STRING");
    };
%%

int main(){
    yyparse();
}
