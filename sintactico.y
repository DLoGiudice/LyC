%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "lista.c"

int yylex();
int yyparse();
void yyerror(char const *str);
void yyerror (char const *s) {
    fprintf (stderr, "%s\n", s);
}
listaPPF *lista;
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

%token TIPO_REAL
%token TIPO_INTEGER
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

%token EQUMIN
%token EQUMAX
%token LONG

%token ID
%token <value_int> ENTERO
%token <value_float> REAL
%token <value_string> CADENA

%%

start: programa{};

programa: sentencia{}; 
        | programa sentencia{};

sentencia: declaracion{/* DIM pi AS REAL*/}
          | factor {/* Solo esta de prueba, BORRAR */}
          | seleccion{/* if a > e then */}
          | asignacion{/* a := 12*/}
          | iteracion{/*  while 2==2*/}
          | display{/*  display*/}
          | long{/*  long([a,b,c,e]) = 4 - long de una lista*/}
          | eq{/*  EQUMAX - EQUMIN - devuelve bool */};

display: DISPLAY CADENA {printf ("Display Cadena");}
       | DISPLAY factor {printf ("Display factor");}
       | DISPLAY expresion {printf ("Display expresion");};

long: LONG PARENTESIS_ABRE CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA {
    printf("LONG DE diferentes factores \n");
};

eq: EQUMAX PARENTESIS_ABRE expresion PUNTO_COMA CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA {printf("EQUMAX: \n");}
  | EQUMIN PARENTESIS_ABRE expresion PUNTO_COMA CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA {printf("EQUMIN: \n");};

iteracion: WHILE PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE programa LLAVE_CIERRA {
    printf ("Iteracion - While");
};

asignacion: ID OP_ASIG factor {printf ("Asignacion - factor");}
          | ID OP_ASIG CADENA {printf ("Asignacion - cadena");}
          | ID OP_ASIG eq {printf ("Asignacion - EQ");}
          | ID OP_ASIG long {printf ("Asignacion - LONG");};
 
declaracion: DIM CORCHETE_ABRE lista_variables CORCHETE_CIERRA AS CORCHETE_ABRE lista_tipo_datos CORCHETE_CIERRA {
    printf("DECLARACION ");
    };

lista_variables: lista_variables COMA ID { printf("Lista de Variables "); }
               | ID  { printf("ID "); };

lista_tipo_datos: lista_tipo_datos COMA tipo_dato  { printf("Lista de Tipos de datos "); }
                |  tipo_dato { printf("Tipo Dato "); };

tipo_dato: TIPO_REAL  { printf("Tipo Real "); }
         | TIPO_INTEGER  { printf("Tipo Integer "); }
         | TIPO_STRING { printf("Tipo String "); };

seleccion: IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE sentencia LLAVE_CIERRA {printf("seleccion ");/*IF ( a <> 4) {sentencia}*/}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE sentencia LLAVE_CIERRA ELSE LLAVE_ABRE LLAVE_CIERRA{/*IF ( a <> 4) {sentencia} else {}*/}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE LLAVE_CIERRA ELSE LLAVE_ABRE sentencia LLAVE_CIERRA{/*IF ( a <> 4) {} else {sentencia}*/}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE sentencia LLAVE_CIERRA ELSE LLAVE_ABRE sentencia LLAVE_CIERRA{/*IF ( a <> 4) {sentencia} else {sentencia}*/};

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

expresion: termino
         | expresion OP_MAS termino { printf("expresion OP_MAS"); }
         | expresion OP_MENOS termino { printf("expresion OP_MENOS"); };

termino: factor
       | termino OP_MUL factor { printf("termino op_mul"); }
       | termino OP_DIV factor { printf("termino op_div"); };

lista_factor: lista_factor COMA expresion  { printf("Lista de factores "); }
            |  expresion { printf("factor tipo: "); };

factor: ID  { insertarLista(lista, crearDato("ss","qq","qqq","qqq"));
    
    printf("factor ID ", "$1"); }
      | ENTERO { printf("factor ENTERO"); } 
      | REAL { printf("factor REAL"); }
      | long { printf("factor LONG"); };
      
operador: OP_MAY{}
        | OP_MEN{}
        | OP_MAY_IGUAL{}
        | OP_MEN_IGUAL{}
        | OP_IGUALIGUAL{}
        | OP_DISTINTO{};
%%

int main(){
    lista = crearLista();
    
    printf("COMIENZA EJECUCION");
    yyparse();

    escribirLista(lista);

}
