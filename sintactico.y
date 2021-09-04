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
    int tipo_integer;  /* Para Enteros. */
}

/* %type <tipo_integer> ENTERO */

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

%%

declaraciones: DIM {
    printf("Token encontrado");
};

%%

int main(){
    yyparse();
}
