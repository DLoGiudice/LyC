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
%token DIM
%%

declaraciones: DIM {
    printf("Token encontrado");
};

%%

int main(){
    yyparse();
}
