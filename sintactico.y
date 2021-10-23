%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "lista.c"
#include "lista_polaca.c"

int yylex();
int yyparse();
void yyerror(char const *str);

//Variables para verificar la coincidencia de lista de variables y lista de tipos.
int contadorListaVariables = 0;
int contadorTipoDato = 0;
int __banderaEquMax = 0;
int __celdaActual_2 = 0;

listaPPF *lista;
listaSimple *listaListaVariables;
listaSimple *listaTipoDato;
listaSimple *listaEqu;

listaPolaca *lPolaca;

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

start: programa{printf("Regla 0\n"); printf("COMPILACION OK\n"); };

programa: sentencia{printf("Regla 1\n");}
        | programa sentencia{printf("Regla 2\n"); };

sentencia: declaracion {printf("Regla 3\n");}
          | seleccion {printf("Regla 4\n");}
          | asignacion {printf("Regla 5\n");}
          | iteracion {printf("Regla 6\n");}
          | display {printf("Regla 7\n");}
          | get {printf("Regla 8\n"); };

display: DISPLAY CADENA { printf ("Display Cadena - Regla 9\n"); 
          char valor[150];
          sprintf(valor, "%s", $2);
          insertarListaPolaca(lPolaca, "DISPLAY");
          insertarListaPolaca(lPolaca, valor);
          }
       | DISPLAY ID { printf ("Display ID - Regla 10\n"); 
          char valor[150];
          sprintf(valor, "%s", $2);
          insertarListaPolaca(lPolaca, "DISPLAY");
          insertarListaPolaca(lPolaca, valor);
          };

get: GET ID { printf("GET ID - Regla 11\n"); 
          char valor[150];
          sprintf(valor, "%s", $2);
          insertarListaPolaca(lPolaca, "GET");
          insertarListaPolaca(lPolaca, valor);
          };

long: LONG PARENTESIS_ABRE CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA {
    printf("LONG ([lista]) - Regla 12\n"); };

eq: EQUMAX PARENTESIS_ABRE expresion {
        __banderaEquMax = 1;
        insertarListaPolaca(lPolaca, "@master");
        insertarListaPolaca(lPolaca, ":=");
    } PUNTO_COMA CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA { 
        printf("EQUMAX(expresion;[lista]) - Regla 13\n");
        insertarListaPolaca(lPolaca, "@master");
        insertarListaPolaca(lPolaca, "@max");
        insertarListaPolaca(lPolaca, "CMP");
        insertarListaPolaca(lPolaca, "BNE");
        insertarListaPolaca(lPolaca, " "); // Avanzar
        insertarListaPolaca(lPolaca, "FALSE");
        insertarListaPolaca(lPolaca, "TRUE");
        // DesapilarCeldaActual. Asignar numero de celda actual a numero de celda desapilada
        
        // insertarEnPolacaEnLugarEspecial
    }
  | EQUMIN PARENTESIS_ABRE expresion PUNTO_COMA CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA { printf("EQUMIN(expresion;[lista]) - Regla 14\n"); };

iteracion: WHILE {printf ("CHAU_________________");} PARENTESIS_ABRE condicion {printf ("HOLA_________________");} PARENTESIS_CIERRA LLAVE_ABRE programa LLAVE_CIERRA {
    printf ("Iteracion  While (Condicion) {Programa} - Regla 15 \n"); };
asignacion: ID OP_ASIG expresion { printf ("Asignacion - expresion - Regla 16\n"); 
            char valor[150];
            sprintf(valor, "%s", $1);
            insertarListaPolaca(lPolaca, valor);
            insertarListaPolaca(lPolaca, ":=");
            }
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
        if (escribirPares(lista,listaListaVariables,listaTipoDato)==1)
            yyerror("Hay un duplicado en la tabla de simbolos");
    }else{
        yyerror ("NO COINCIDEN LAS CANTIDADES - msj de error \n");
    }

    contadorListaVariables = 0;
    contadorTipoDato = 0;
    printf("DECLARACION - DIM [Lista variables] AS [lista tipo de dato] - Regla 19\n"); };

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
                printf("Tipo de dato - Regla 23\n"); };

tipo_dato: TIPO_REAL { printf("Tipo Real - Regla 24\n");
        insertarListaSimple(listaTipoDato, "CTE_FLOAT");
       }
         | TIPO_INTEGER { printf("Tipo Integer - Regla 25\n");
        insertarListaSimple(listaTipoDato, "CTE_INTEGER");
       }
         | TIPO_STRING { printf("Tipo String - Regla 26\n");
        insertarListaSimple(listaTipoDato, "CTE_STRING"); };

seleccion: IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE sentencia LLAVE_CIERRA { printf("Seleccion - IF (condicion) {sentencia} - Regla 27\n");}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE sentencia LLAVE_CIERRA ELSE LLAVE_ABRE LLAVE_CIERRA{printf("Seleccion - IF (condicion) {sentencia} ELSE {} - Regla 29\n");}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE LLAVE_CIERRA ELSE LLAVE_ABRE sentencia LLAVE_CIERRA{printf("Seleccion - IF (condicion) {} ELSE {sentencia} - Regla 30\n");}
        | IF PARENTESIS_ABRE condicion PARENTESIS_CIERRA LLAVE_ABRE sentencia LLAVE_CIERRA ELSE LLAVE_ABRE sentencia LLAVE_CIERRA{printf("Seleccion - IF (condicion) {sentencia} ELSE {sentencia} - Regla 31\n");};

condicion: comparacion {
    printf("Comparacion - Regla 32\n"); }
        | comparacion AND comparacion{printf("Comparacion AND Comparacion - Regla 33\n");}
        | comparacion OR comparacion{printf("Comparacion OR Comparacion - Regla 34\n");}
        | NOT comparacion{printf("NOT Comparacion - Regla 35\n"); };

comparacion: expresion operador expresion{printf("Comparacion - Regla 36\n");}
            | PARENTESIS_ABRE expresion operador expresion PARENTESIS_CIERRA{printf("Comparacion - (expresion op expresion) Regla 37\n");}
            | eq{printf("Comparacion - eq - Regla 38\n"); };

expresion: termino{printf("expresion - termino - Regla 39\n");}
         | expresion OP_MAS termino {printf("expresion OP_MAS termino - Regla 40\n");
                insertarListaPolaca(lPolaca, "OP_MAS");}
         | expresion OP_MENOS termino {printf("expresion OP_MENOS termino - Regla 41\n");
                insertarListaPolaca(lPolaca, "OP_MENOS");
                };

termino: factor{printf("termino - factor - Regla 42\n");}
       | termino OP_MUL factor {printf("termino OP_MUL factor - Regla 43\n");
       insertarListaPolaca(lPolaca, "OP_MUL");}
       | termino OP_DIV factor {printf("termino OP_DIV factor - Regla 44\n"); 
       insertarListaPolaca(lPolaca, "OP_DIV");
       };

lista_factor: lista_factor COMA expresion {
                printf("Lista_factor COMA expresion - Regla 45\n");
                 if (__banderaEquMax == 1) {
                    char __posicionDestino[150];
                    char __celdaActual[150];
                    char * aux;
                    insertarListaPolaca(lPolaca, "@aux");
                    insertarListaPolaca(lPolaca, ":=");
                    insertarListaPolaca(lPolaca, "@aux");
                    insertarListaPolaca(lPolaca, "@max");
                    insertarListaPolaca(lPolaca, "CMP");
                    insertarListaPolaca(lPolaca, "BLE");
                    // Apilo celdaActual
                    sprintf(__celdaActual, "%d", celdaActual(lPolaca));
                    printf("CELDA ACTUAL 1: %s\n", __celdaActual);
                    insertarListaSimple(listaEqu, __celdaActual);

                    insertarListaPolaca(lPolaca, " "); // Avanzar
                    // Detecto maximo, asigna a Aux
                    insertarListaPolaca(lPolaca, "@aux");
                    insertarListaPolaca(lPolaca, "@max");
                    insertarListaPolaca(lPolaca, ":=");

                    // Desapilo la posicion en donde voy a guardar la nueva celda actual.
                    aux = desapilarDeLista(listaEqu, __posicionDestino);
                    sprintf(__celdaActual, "%d", celdaActual(lPolaca));
                    printf("posicion__Destino: %s\n", aux);
                    printf("CELDA ACTUAL 2: %s\n", __celdaActual);
                    insertarListaPolacaNodoEspecifica(lPolaca, __celdaActual, __posicionDestino);
                    // insertarListaPolaca(lPolaca[salto], actual)
                }
            }
            | expresion { 
                printf("lista_factor: expresion - Regla 46\n");
                if (__banderaEquMax == 1) {
                    insertarListaPolaca(lPolaca, "@max");
                    insertarListaPolaca(lPolaca, ":=");
                }
            };

factor: ID {
    insertarListaPolaca(lPolaca, $1); 
    printf("factor ID - Regla 47\n"); }
      | ENTERO {
          printf("factor ENTERO - Regla 48\n"); 
          char nombre[150] = "_";
          char valor[150];
          sprintf(valor, "%d", $1);
          insertarListaPolaca(lPolaca, valor);
          detectarInsertar(lista, crearDato(strcat(nombre, valor), "-", valor, "-")); }
      | REAL { 
          printf("factor REAL - Regla 49\n");
          char nombre[150] = "_";
          char valor[150];
          sprintf(valor, "%.4f", $1);
          insertarListaPolaca(lPolaca, valor);
          detectarInsertar(lista, crearDato(strcat(nombre, valor), "-", valor, "-")); }
      | long { 
          // insertarListaPolaca(lPolaca, $1);
          printf("factor LONG - Regla 50\n"); };
      
operador: OP_MAY{printf("Operador OP_MAY - Regla 51\n");}
        | OP_MEN{printf("Operador OP_MEN - Regla 52\n");}
        | OP_MAY_IGUAL{printf("Operador OP_MAY_IGUAL - Regla 53\n");}
        | OP_MEN_IGUAL{printf("Operador OP_MEN_IGUAL - Regla 54\n");}
        | OP_IGUALIGUAL{printf("Operador OP_IGUALIGUAL - Regla 55\n");}
        | OP_DISTINTO{printf("Operador OP_DISTINTO - Regla 56\n"); };
%%

int main(){
    lista = crearLista();
    listaTipoDato = crearListaSimple();
    listaListaVariables = crearListaSimple();
    listaEqu = crearListaSimple();

    lPolaca = crearListaPolaca();
    yyparse();
    escribirLista(lista);
    escribirListaPolaca(lPolaca);    
}

void yyerror (char const *s) {
    printf("Programa terminado por error \n");
    exit(1);
}
