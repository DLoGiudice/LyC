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

listaSimple *listaListaVariables;
listaSimple *listaTipoDato;

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
%type <value_string> ID CADENA TIPO_STRING TIPO_INTEGER TIPO_REAL tipo_dato

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

start: programa{printf("COMPILACION OK\n"); printf("Regla 0\n");};

programa: sentencia{printf("Regla 1\n");}
        | programa sentencia{printf("Regla 2\n");};

sentencia: declaracion {printf("Regla 3\n");}
          | seleccion {printf("Regla 4\n");}
          | asignacion {printf("Regla 5\n");}
          | iteracion {printf("Regla 6\n");}
          | display {printf("Regla 7\n");}
          | get {printf("Regla 8\n");};

display: DISPLAY CADENA { printf ("Display Cadena - Regla 9\n"); }
       | DISPLAY expresion { printf ("Display expresion - Regla 10\n"); };

get: GET ID { printf("GET ID - Regla 11\n"); };

long: LONG PARENTESIS_ABRE CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA {
    printf("LONG ([lista]) - Regla 12\n");
};

eq: EQUMAX PARENTESIS_ABRE expresion PUNTO_COMA CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA { printf("EQUMAX(expresion;[lista]) - Regla 13\n"); }
  | EQUMIN PARENTESIS_ABRE expresion PUNTO_COMA CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA { printf("EQUMIN(expresion;[lista]) - Regla 14\n"); };

iteracion: WHILE PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE programa LLAVE_CIERRA {
    printf ("Iteracion  While (Condicion) {Programa} - Regla 15 \n"); };
asignacion: ID OP_ASIG factor { printf ("Asignacion - factor - Regla 16\n"); }
          | ID OP_ASIG CADENA {
            char longitud[2] = "";
            char nombre[33] = "_";
            sprintf(longitud, "%d", (int)strlen($3));
            if (detectarInsertar(lista, crearDato(strcat(nombre, $3),"-", $3, longitud))==1){
                yyerror("Hay un duplicado en la tabla de simbolos");
             }
            printf ("Asignacion - cadena - Regla 17\n"); }
          | ID OP_ASIG eq { printf ("Asignacion - EQ - Regla 18\n"); };
 
declaracion: DIM CORCHETE_ABRE lista_variables CORCHETE_CIERRA AS CORCHETE_ABRE lista_tipo_datos CORCHETE_CIERRA {
    
    if(contadorListaVariables == contadorTipoDato){
        printf ("COINCIDEN LAS CANTIDADES \n");
        if (escribirPares(lista,listaListaVariables,listaTipoDato)==1)
            yyerror("Hay un duplicado en la tabla de simbolos");
        }else{
        printf ("NO COINCIDEN LAS CANTIDADES \n");
        yyerror ("NO COINCIDEN LAS CANTIDADES - msj de error \n");
    }

    contadorListaVariables = 0;
    contadorTipoDato = 0;
    printf("DECLARACION - DIM [Lista variables] AS [lista tipo de dato] - Regla 19\n");
    };

lista_variables: lista_variables COMA ID { 
                    contadorListaVariables++;
                char nombre[33] = "_";
                strcat(nombre, $3);
                insertarListaSimple(listaListaVariables, nombre);     
                printf("Lista de Variables - Regla 20\n"); }
               | ID  { 
                   contadorListaVariables++;
                char nombre[33] = "_";
                strcat(nombre, $1);
                insertarListaSimple(listaListaVariables, nombre);    
                   printf("ID - Regla 21\n"); };

lista_tipo_datos: lista_tipo_datos COMA tipo_dato  { 
                contadorTipoDato++;
                printf("Lista de Tipos de datos - Regla 22\n"); }
                |tipo_dato
                { 
                contadorTipoDato++;
                printf("Tipo de dato - Regla 23\n");
                };

tipo_dato: TIPO_REAL { printf("Tipo Real - Regla 24\n");
        insertarListaSimple(listaTipoDato, "Real");
       }
         | TIPO_INTEGER { printf("Tipo Integer - Regla 25\n");
        insertarListaSimple(listaTipoDato, "Integer");
       }
         | TIPO_STRING { printf("Tipo String - Regla 26\n");
        insertarListaSimple(listaTipoDato, "String");
       };

seleccion: IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE sentencia LLAVE_CIERRA { printf("Seleccion - IF (condicion) {sentencia} - Regla 27\n");}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE sentencia LLAVE_CIERRA ELSE LLAVE_ABRE LLAVE_CIERRA{printf("Seleccion - IF (condicion) {sentencia} ELSE {} - Regla 29\n");}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE LLAVE_CIERRA ELSE LLAVE_ABRE sentencia LLAVE_CIERRA{printf("Seleccion - IF (condicion) {} ELSE {sentencia} - Regla 30\n");}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE sentencia LLAVE_CIERRA ELSE LLAVE_ABRE sentencia LLAVE_CIERRA{printf("Seleccion - IF (condicion) {sentencia} ELSE {sentencia} - Regla 31\n");};

condicion: comparacion {printf("Comparacion - Regla 32\n"); }
        | comparacion AND comparacion{printf("Comparacion AND Comparacion - Regla 33\n");}
        | comparacion OR comparacion{printf("Comparacion OR Comparacion - Regla 34\n");}
        | NOT comparacion{printf("NOT Comparacion - Regla 35\n");};

comparacion: expresion operador expresion{printf("Comparacion - Regla 36\n");}
            | PARENTESIS_ABRE expresion operador expresion PARENTESIS_CIERRA{printf("Comparacion - (expresion op expresion) Regla 37\n");}
            | eq{printf("Comparacion - eq - Regla 38\n");};

expresion: termino{printf("expresion - termino - Regla 39\n");}
         | expresion OP_MAS termino {printf("expresion OP_MAS termino - Regla 40\n");}
         | expresion OP_MENOS termino {printf("expresion OP_MENOS termino - Regla 41\n"); };

termino: factor{printf("termino - factor - Regla 42\n");}
       | termino OP_MUL factor {printf("termino OP_MUL factor - Regla 43\n");}
       | termino OP_DIV factor {printf("termino OP_DIV factor - Regla 44\n");};

lista_factor: lista_factor COMA expresion  { printf("Lista_factor COMA expresion - Regla 45\n"); }
            |  expresion { printf("lista_factor: expresion - Regla 46\n"); };

factor: ID { printf("factor ID - Regla 47\n"); }
      | ENTERO { printf("factor ENTERO - Regla 48\n"); 
          char nombre[150] = "_";
          char valor[150];
          sprintf(valor, "%d", $1);
            if (detectarInsertar(lista, crearDato(strcat(nombre, valor), "-", valor, "-"))==1){
                yyerror("Hay un duplicado en la tabla de simbolos");
            }
            }
      | REAL { printf("factor REAL - Regla 49\n");
          char nombre[150] = "_";
          char valor[150];
          sprintf(valor, "%.4f", $1);
            if (detectarInsertar(lista, crearDato(strcat(nombre, valor), "-", valor, "-"))==1){
                yyerror("Hay un duplicado en la tabla de simbolos");
            }
          }
      | long { printf("factor LONG - Regla 50\n"); };
      
operador: OP_MAY{printf("Operador OP_MAY - Regla 51\n");}
        | OP_MEN{printf("Operador OP_MEN - Regla 52\n");}
        | OP_MAY_IGUAL{printf("Operador OP_MAY_IGUAL - Regla 53\n");}
        | OP_MEN_IGUAL{printf("Operador OP_MEN_IGUAL - Regla 54\n");}
        | OP_IGUALIGUAL{printf("Operador OP_IGUALIGUAL - Regla 55\n");}
        | OP_DISTINTO{printf("Operador OP_DISTINTO - Regla 56\n");};
%%

int main(){
    lista = crearLista();
    listaTipoDato = crearListaSimple();
    listaListaVariables = crearListaSimple();
    printf("COMIENZA EJECUCION");
    yyparse();
    escribirLista(lista);
}

void yyerror (char const *s) {
    fprintf (stderr, "\n %s \n", s);
    printf("me fui del programa \n");
    exit(1);
}
