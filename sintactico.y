%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "lista.c"

int yylex();
int yyparse();
void yyerror(char const *str);

//Variables para verificar la coincidencia de lista de variables y lista de tipos.
int contadorListaVariables = 0;
int contadorTipoDato = 0;

listaPPF *lista;
%}

%union
{   /* Comunicacion con el lexico, defino tipos de datos para los tokens */
    int value_int;  /* Para Enteros. */
    float value_float;  /* Para reales. */
    char* value_string;  /* Para strings. */
}

//Tipos que defino para el lexico
%type <value_int> ENTERO
%type <value_float> REAL
%type <value_string> ID CADENA

%token ID
%token ENTERO
%token REAL
%token CADENA

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

%%

start: programa{};

programa: sentencia{}; 
        | programa sentencia{};

sentencia: declaracion{/* DIM pi AS REAL*/}
          | seleccion{/* if a > e then */}
          | asignacion{/* a := 12*/}
          | iteracion{/*  while 2==2*/}
          | display{/*  display*/}
          | long{/*  long([a,b,c,e]) = 4 - long de una lista*/}
          | eq{/*  EQUMAX - EQUMIN - devuelve bool */};

display: DISPLAY CADENA {printf ("Display Cadena");}
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
          | ID OP_ASIG eq {printf ("Asignacion - EQ");};
 
declaracion: DIM CORCHETE_ABRE lista_variables CORCHETE_CIERRA AS CORCHETE_ABRE lista_tipo_datos CORCHETE_CIERRA {
    
    if(contadorListaVariables == contadorTipoDato){
        printf ("COINCIDEN LAS CANTIDADES \n");
        }else{
        printf ("NO COINCIDEN LAS CANTIDADES \n");
        yyerror ("NO COINCIDEN LAS CANTIDADES - msj de error \n");
    }

    contadorListaVariables = 0;
    contadorTipoDato = 0;
    printf("DECLARACION");
    };

lista_variables: lista_variables COMA ID { 
                    contadorListaVariables++;
                printf("Lista de Variables %d \n", contadorListaVariables); }
               | ID  { 
                   contadorListaVariables++;
                   printf("ID - CONTADOR %d \n", contadorListaVariables); };

lista_tipo_datos: lista_tipo_datos COMA tipo_dato  { 
                contadorTipoDato++;
                printf("Lista de Tipos de datos "); }
                |  tipo_dato { 
                    contadorTipoDato++;
                    printf("Tipo Dato "); };

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

factor: ID { printf("factor ID %s", $1);}
      | ENTERO { printf("factor ENTERO %d", $1); }
      | REAL {
          char nombre[30];
          sprintf(nombre, "%.4f", $1);
            if (detectarInsertar(lista, crearDato(nombre,"REAL","-","-"))==1){
                yyerror("Hay un duplicado en la tabla de simbolos");
            }
          }
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

void yyerror (char const *s) {
    fprintf (stderr, "\n %s \n", s);
    printf("me fui del programa \n");
    exit(1);
}
