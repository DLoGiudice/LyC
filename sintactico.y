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
%token THEN
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

start: programa{};

programa: sentencia{}; 
        | programa sentencia{};

sentencia: seleccion{/* if a > e then */} 
        | asignacion{/* a := 12*/}
        | iteracion{/*  while 2==2*/}
        | definicion{/* DIM pi AS REAL*/};

seleccion: IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA THEN {/* IF ( a <> 4) THEN*/}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA THEN LLAVE_ABRE LLAVE_CIERRA {/*IF ( a <> 4) THEN {}*/}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA THEN LLAVE_ABRE programa LLAVE_CIERRA {/*IF ( a <> 4) THEN {programa}*/}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA THEN LLAVE_ABRE programa LLAVE_CIERRA ELSE LLAVE_ABRE LLAVE_CIERRA{/*IF ( a <> 4) THEN {programa} else {}*/}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA THEN LLAVE_ABRE LLAVE_CIERRA ELSE LLAVE_ABRE programa LLAVE_CIERRA{/*IF ( a <> 4) THEN {} else {programa}*/}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA THEN LLAVE_ABRE programa LLAVE_CIERRA ELSE LLAVE_ABRE programa LLAVE_CIERRA{/*IF ( a <> 4) THEN {programa} else {programa}*/};

condicion: comparacion {/*x == 22
                        (x == 22)*/}
        | comparacion AND comparacion{/*x == 22 AND f < 22
                                        (x == 22) AND f < 22
                                        x == 22 AND (f < 22)
                                        (x == 22) AND (f < 22)*/}
        | comparacion OR comparacion{/*x == 22 OR f < 22
                                        (x == 22) OR f < 22
                                        x == 22 OR (f < 22)
                                        (x == 22) OR (f < 22)*/}
        | NOT comparacion{/*NOT x > 22
                            NOT (x > 22)*/};

comparacion: expresion operador expresion{/*c > 33.3
                                            4 <> 3
                                            a == b */}
            | PARENTESIS_ABRE expresion operador expresion PARENTESIS_CIERRA{/*(c > 33.3)
                                                                                (4 <> 3)
                                                                                (a == b)*/};

expresion: ID{/*a12*/}
        | CONSTANTE{/*1233
                    1233.3123*/};

operador: OP_MAY{}
        | OP_MEN{}
        | OP_MAY_IGUAL{}
        | OP_MEN_IGUAL{}
        | OP_IGUALIGUAL{}
        | OP_DISTINTO{};

%%

// Tener en cuenta que no permito (a == (b)), es decir los parentesis de b, para eso deberia poner 
// expresion: PARENTESIS_ABRE ID PARENTESIS_CIERRA{}

int main(){
    yyparse();
}
