%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "lista.c"
#include "lista_polaca.c"
#include "assembler.c"

int yylex();
int yyparse();
void yyerror(char const *str);

//Variables para verificar la coincidencia de lista de variables y lista de tipos.
int contadorListaVariables = 0;
int contadorTipoDato = 0;
int __banderaEquMax = 0;
int __banderaIf = 0;
int __banderaAnd = 0;
int __lista_while = 0;
int __lista_if = 0;
int __cantidad_if = 0;
char * __operador__comparador;
int __banderaEquMin = 0;
int __if_anidados = 0;
int __contador_cadenas = 0;


int contLong = 0;

listaPPF *lista;
listaSimple *listaListaVariables;
listaSimple *listaTipoDato;
listaSimple *listaEqu;
listaSimple *listaIf;
listaSimple *listaIf2;
listaSimple *listaWhile;
listaSimple *listaWhileInicio;
listaSimple *listaComparacion;

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
          | asignacion {printf("Regla 5 \n");}
          | iteracion {printf("Regla 6\n");}
          | display {printf("Regla 7\n");}
          | get {printf("Regla 8\n"); };

display: DISPLAY CADENA {
            printf ("Display Cadena - Regla 9\n");
            char valor[150];
            char numero_cadena[150];
            char nombre[150] = "_cadena_";
            char __celdaActual[150];
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            sprintf(valor, "%s", $2);
            sprintf(numero_cadena, "%d", __contador_cadenas);
            insertarListaPolaca(lPolaca, "DISPLAY");
            strcat(nombre, numero_cadena);
            sprintf(valor, "\"%s\"", $2);
            detectarInsertar(lista, crearDato(nombre, "CTE_STRING", valor, "-"));
            insertarListaPolaca(lPolaca, nombre);
            __contador_cadenas = __contador_cadenas + 1;
        }
       | DISPLAY ID { printf ("Display ID - Regla 10\n");
            char valor[150];
            char nombre[150] = "_";
            sprintf(valor, "%s", $2);
            insertarListaPolaca(lPolaca, "DISPLAY");
            insertarListaPolaca(lPolaca, strcat(nombre, valor));
        };

get: GET ID {
        printf("GET ID - Regla 11\n");
        char nombre[150] = "_";
        char valor[150];
        sprintf(valor, "%s", $2);
        insertarListaPolaca(lPolaca, "GET");
        insertarListaPolaca(lPolaca, strcat(nombre, valor));
        };

long: LONG PARENTESIS_ABRE CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA {
    char valor[150];
    char valorAux[150] = "_";
    sprintf(valor, "%d", contLong);
    strcat(valorAux, valor);
    strcat(valor, ".0");
    insertarListaPolaca(lPolaca, valorAux);
    detectarInsertar(lista, crearDato(valorAux, "CTE_INTEGER", valor, "-"));
    printf("LONG ([lista]) - Regla 12\n");
    };

eq: EQUMAX PARENTESIS_ABRE {
        __banderaEquMax = 1;
    }expresion {
        insertarListaPolaca(lPolaca, "OP_ASIG");
        insertarListaPolaca(lPolaca, "@master");
        detectarInsertar(lista, crearDato("@master", "-", "-", "-"));
    } PUNTO_COMA CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA {
        char __posicionDestinoEquMax[150];
        char __celdaActualEquMax[150];

        printf("EQUMAX(expresion;[lista]) - Regla 13\n");
        insertarListaPolaca(lPolaca, "@master");
        insertarListaPolaca(lPolaca, "@max");
         detectarInsertar(lista, crearDato("@max", "-", "-", "-"));
        __operador__comparador = "BNE";
        sprintf(__celdaActualEquMax, "%d", celdaActual(lPolaca));
        __banderaEquMax = 0;
    }
  | EQUMIN PARENTESIS_ABRE {
        __banderaEquMin = 1;
  } expresion {
        insertarListaPolaca(lPolaca, "OP_ASIG");
        insertarListaPolaca(lPolaca, "@master");
        detectarInsertar(lista, crearDato("@master", "-", "-", "-"));
  } PUNTO_COMA CORCHETE_ABRE lista_factor CORCHETE_CIERRA PARENTESIS_CIERRA {
        char __posicionDestinoEquMin[150];
        char __celdaActualEquMin[150];

        printf("EQUMIN(expresion;[lista]) - Regla 14\n");
        insertarListaPolaca(lPolaca, "@master");
        insertarListaPolaca(lPolaca, "@min");
        detectarInsertar(lista, crearDato("@min", "-", "-", "-"));
        __operador__comparador = "BNE";
        sprintf(__celdaActualEquMin, "%d", celdaActual(lPolaca));
        __banderaEquMin = 0;
    };

iteracion: WHILE {
            char __posicionDestino[150];
            char __celdaActual[150];
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));

            insertarListaSimple(listaWhileInicio, __celdaActual);
            insertarListaPolaca(lPolaca, "ET"); // Etiqueta
        } PARENTESIS_ABRE {
            __lista_while = 1;
        } condicion {
            __lista_while = 0;
        } PARENTESIS_CIERRA LLAVE_ABRE programa LLAVE_CIERRA {
            char __posicionDestino[150];
            char __celdaActual[150];
            char __auxString[150];
            int __celdaActualInt;

            insertarListaPolaca(lPolaca, "BIBI");
            // Inserto posicion de la etiqueta
            desapilarDeLista(listaWhile, __posicionDestino);
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            __celdaActualInt = atoi(__celdaActual);
            __celdaActualInt++;
            sprintf(__auxString, "%d", __celdaActualInt);
            // Inserto el la posicion que saque de pila el auxiliar que ya le sume 1.
            insertarListaPolacaNodoEspecifica(lPolaca, __auxString, __posicionDestino);

            // Para el AND: If pila vacia, sigo (significa solo una condicion).
            // sino pongo el mismo valor que antes ya que si alguna es falsa ya salta al ELSE
            if (!listaVacia(listaWhile)) {
                desapilarDeLista(listaWhile, __posicionDestino);
                insertarListaPolacaNodoEspecifica(lPolaca, __auxString, __posicionDestino);
            }

             //Saco de pila inserto posicion de la etiqueta en celda actual.
            desapilarDeLista(listaWhileInicio, __posicionDestino);
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            insertarListaPolaca(lPolaca, " ");
            insertarListaPolacaNodoEspecifica(lPolaca, __posicionDestino, __celdaActual);
            printf ("Iteracion  While (Condicion) {Programa} - Regla 15 \n");
        };

asignacion: ID OP_ASIG expresion { printf ("Asignacion - expresion - Regla 16\n");
            char nombre[150] = "_";
            char valor[150];
            sprintf(valor, "%s", $1);
            insertarListaPolaca(lPolaca, "OP_ASIG");
            insertarListaPolaca(lPolaca, strcat(nombre, valor));
            }
          | ID OP_ASIG CADENA {
            char longitud[2] = "";
            char nombre[33] = "_";
            char nombre_valor[40] = "";
            sprintf(longitud, "%d", (int)strlen($3));
            sprintf(nombre_valor, "\"%s\"", $3);
            if (detectarInsertar(lista, crearDato(strcat(nombre, $3),"CTE_STRING", nombre_valor, longitud))==1){
                yyerror("Hay un duplicado en la tabla de simbolos");
             }
            char valor[150];
            sprintf(valor, "%s", $3);
            insertarListaPolaca(lPolaca, valor);
            insertarListaPolaca(lPolaca, "OP_ASIG");
            insertarListaPolaca(lPolaca, $1);
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

seleccion: IF PARENTESIS_ABRE inicio_lista_if condicion fin_lista_if PARENTESIS_CIERRA LLAVE_ABRE programa LLAVE_CIERRA ELSE {
            char __posicionDestino[150];
            char __celdaActual[150];
            int __celdaActualInt;

            if (__cantidad_if == 1) {
                listaComparacion = listaIf;
            } else {
                listaComparacion = listaIf2;
            }

            insertarListaPolaca(lPolaca, "BI");
            desapilarDeLista(listaComparacion, __posicionDestino);
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));

            // La ppt dice que hay que sumar 1
            __celdaActualInt = atoi(__celdaActual);
            __celdaActualInt++;
            sprintf(__celdaActual, "%d", __celdaActualInt);
            insertarListaPolacaNodoEspecifica(lPolaca, __celdaActual, __posicionDestino);

            // Para el AND: If pila vacia, sigo (significa solo una condicion).
            // sino pongo el mismo valor que antes ya que si alguna es falsa ya salta al ELSE
            if (!listaVacia(listaComparacion)) {
                desapilarDeLista(listaComparacion, __posicionDestino);
                insertarListaPolacaNodoEspecifica(lPolaca, __celdaActual, __posicionDestino);
            }

            __celdaActualInt = atoi(__celdaActual);
            __celdaActualInt--;
            sprintf(__celdaActual, "%d", __celdaActualInt);
            insertarListaSimple(listaComparacion, __celdaActual);
            insertarListaPolaca(lPolaca, " "); // Avanzar
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));

        } LLAVE_ABRE programa LLAVE_CIERRA {
            char __posicionDestino[150];
            char __celdaActual[150];

            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            desapilarDeLista(listaComparacion, __posicionDestino);
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            // La ppt dice que hay que sumar 1
            int __celdaActualInt = atoi(__celdaActual);
            __celdaActualInt;
            sprintf(__celdaActual, "%d", __celdaActualInt);
            insertarListaPolacaNodoEspecifica(lPolaca, __celdaActual, __posicionDestino);
            __celdaActualInt = atoi(__celdaActual);
            __celdaActualInt--;
            sprintf(__celdaActual, "%d", __celdaActualInt);
            __cantidad_if--;
            printf("Seleccion - IF (condicion) {programa} ELSE {programa} - Regla 27\n");
        }
        | IF PARENTESIS_ABRE inicio_lista_if condicion fin_lista_if PARENTESIS_CIERRA LLAVE_ABRE programa LLAVE_CIERRA {
            char __posicionDestino[150];
            char __celdaActual[150];
            if (__cantidad_if == 1) {
                listaComparacion = listaIf;
            } else {
                listaComparacion = listaIf2;
            }

            desapilarDeLista(listaComparacion, __posicionDestino);
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));

            insertarListaPolacaNodoEspecifica(lPolaca, __celdaActual, __posicionDestino);

            // Para el AND: If pila vacia, sigo (significa solo una condicion).
            // sino pongo el mismo valor que antes ya que si alguna es falsa ya salta al ELSE
            if (!listaVacia(listaComparacion)) {
                desapilarDeLista(listaComparacion, __posicionDestino);
                insertarListaPolacaNodoEspecifica(lPolaca, __celdaActual, __posicionDestino);
            }

            __cantidad_if--;
            printf("Seleccion - IF (condicion) {sentencia} - Regla 28\n");};

inicio_lista_if: {
            __lista_if = 1;
            __cantidad_if++;
            };

fin_lista_if: {
            __lista_if = 0;
            };

condicion: comparacion {
            printf("Comparacion - Regla 29\n");
            char __posicionDestino[150];
            char __celdaActual[150];

            insertarListaPolaca(lPolaca, "CMP");
            insertarListaPolaca(lPolaca, __operador__comparador);
            __operador__comparador = "";
            // Apilo celdaActual
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            if( __lista_if == 1) {
                if (__cantidad_if == 1) {
                    insertarListaSimple(listaIf, __celdaActual);
                } else {
                    insertarListaSimple(listaIf2, __celdaActual);
                }
            }

            if( __lista_while == 1)
                insertarListaSimple(listaWhile, __celdaActual);
            insertarListaPolaca(lPolaca, " "); // Avanzar
        }
        | comparacion {
            char __posicionDestino[150];
            char __celdaActual[150];

            insertarListaPolaca(lPolaca, "CMP");
            insertarListaPolaca(lPolaca, __operador__comparador);
            __operador__comparador = "";
            // Apilo celdaActual
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            if( __lista_if == 1) {
                if (__cantidad_if == 1) {
                    insertarListaSimple(listaIf, __celdaActual);
                } else {
                    insertarListaSimple(listaIf2, __celdaActual);
                }
            }

            if( __lista_while == 1)
                insertarListaSimple(listaWhile, __celdaActual);
            insertarListaPolaca(lPolaca, " "); // Avanzar
        } AND comparacion {
            char __posicionDestino[150];
            char __celdaActual[150];
            __banderaAnd = 1;

            printf("Comparacion AND Comparacion - Regla 30\n");
            insertarListaPolaca(lPolaca, "CMP");
            insertarListaPolaca(lPolaca, __operador__comparador);
            __operador__comparador = "";
            // Apilo celdaActual
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            if( __lista_if == 1) {
                if (__cantidad_if == 1) {
                    insertarListaSimple(listaIf, __celdaActual);
                } else {
                    insertarListaSimple(listaIf2, __celdaActual);
                }
            }

            if( __lista_while == 1)
                insertarListaSimple(listaWhile, __celdaActual);
            insertarListaPolaca(lPolaca, " "); // Avanzar

        }
        | comparacion {
            char __posicionDestino[150];
            char __celdaActual[150];

            insertarListaPolaca(lPolaca, "CMP");
            insertarListaPolaca(lPolaca, __operador__comparador);
            __operador__comparador = "";
            // Apilo celdaActual
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            if( __lista_if == 1) {
                if (__cantidad_if == 1) {
                    insertarListaSimple(listaIf, __celdaActual);
                } else {
                    insertarListaSimple(listaIf2, __celdaActual);
                }
            }

            if( __lista_while == 1)
                insertarListaSimple(listaWhile, __celdaActual);
            insertarListaPolaca(lPolaca, " "); // Avanzar
        } OR comparacion{
            printf("Comparacion OR Comparacion - Regla 31\n");
            char __posicionDestino[150];
            char __celdaActual[150];
            char __posicionSaltoOr[150];

            // Desapilo antes de insertar. Para el OR.
            if( __lista_if == 1)
                desapilarDeLista(listaIf, __posicionSaltoOr);

            if( __lista_while == 1)
                desapilarDeLista(listaWhile, __posicionSaltoOr);

            insertarListaPolaca(lPolaca, "CMP");
            insertarListaPolaca(lPolaca, __operador__comparador);
            __operador__comparador = "";
            // Apilo celdaActual
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            if( __lista_if == 1) {
                if (__cantidad_if == 1) {
                    insertarListaSimple(listaIf, __celdaActual);
                } else {
                    insertarListaSimple(listaIf2, __celdaActual);
                }
            }

            if( __lista_while == 1)
                insertarListaSimple(listaWhile, __celdaActual);

            insertarListaPolaca(lPolaca, " "); // Avanzar

            // Como es un OR, si es verdadera la primera condicion, salta aca. Al inicio del programa
            sprintf(__celdaActual, "%d", celdaActual(lPolaca));
            insertarListaPolacaNodoEspecifica(lPolaca, __celdaActual, __posicionSaltoOr);

        }
        | NOT comparacion{printf("NOT Comparacion - Regla 32\n"); };

comparacion: expresion {
             } operador expresion{printf("Comparacion - Regla 33\n");}
           | PARENTESIS_ABRE expresion {
             } operador expresion PARENTESIS_CIERRA {printf("Comparacion - (expresion op expresion) Regla 34\n");}
           | eq{printf("Comparacion - eq - Regla 35\n"); };

expresion: termino{printf("expresion - termino - Regla 36\n");}
         | expresion OP_MAS termino {printf("expresion OP_MAS termino - Regla 37\n");
                insertarListaPolaca(lPolaca, "OP_MAS");}
         | expresion OP_MENOS termino {printf("expresion OP_MENOS termino - Regla 38\n");
                insertarListaPolaca(lPolaca, "OP_MENOS");
                };

termino: factor{printf("termino - factor - Regla 39\n");}
       | termino OP_MUL factor {
            printf("termino OP_MUL factor - Regla 40\n");
            insertarListaPolaca(lPolaca, "OP_MUL");}
       | termino OP_DIV factor {
            printf("termino OP_DIV factor - Regla 41\n");
            insertarListaPolaca(lPolaca, "OP_DIV");
       };

lista_factor: lista_factor COMA expresion {
                printf("Lista_factor COMA expresion - Regla 42\n");
                 if (__banderaEquMax == 1 || __banderaEquMin == 1 ) {
                    char * maxOMin = (__banderaEquMax == 1) ? "@max" : "@min";
                    char __posicionDestino[150];
                    char __celdaActual[150];

                    insertarListaPolaca(lPolaca, "OP_ASIG");
                    insertarListaPolaca(lPolaca, "@equ_aux");
                    detectarInsertar(lista, crearDato("@equ_aux", "-", "-", "-"));
                    insertarListaPolaca(lPolaca, "@equ_aux");
                    // Inserto @max o @min dependiendo la bandera.
                    insertarListaPolaca(lPolaca, maxOMin);
                    insertarListaPolaca(lPolaca, "CMP");
                    // Inserto BLE o BGE dependiendio si es EQUMAX o EQUMIN
                    (__banderaEquMax == 1) ? insertarListaPolaca(lPolaca, "BLE") : insertarListaPolaca(lPolaca, "BGE");
                    // Apilo celdaActual
                    sprintf(__celdaActual, "%d", celdaActual(lPolaca));
                    insertarListaSimple(listaEqu, __celdaActual);
                    insertarListaPolaca(lPolaca, " "); // Avanzar
                    // Detecto maximo, asigna a Aux
                    insertarListaPolaca(lPolaca, "@equ_aux");
                    // Inserto @max o @min dependiendo la bandera.
                    insertarListaPolaca(lPolaca, "OP_ASIG");
                    insertarListaPolaca(lPolaca, maxOMin);
                    // Desapilo la posicion en donde voy a guardar la nueva celda actual.
                    desapilarDeLista(listaEqu, __posicionDestino);
                    sprintf(__celdaActual, "%d", celdaActual(lPolaca));
                    insertarListaPolacaNodoEspecifica(lPolaca, __celdaActual, __posicionDestino);
                } else {
                    contLong++;
                }
            }
            | expresion {
                printf("lista_factor: expresion - Regla 43\n");
                if (__banderaEquMax == 1 || __banderaEquMin == 1 ) {
                    insertarListaPolaca(lPolaca, "OP_ASIG");
                    (__banderaEquMax == 1) ? insertarListaPolaca(lPolaca, "@max") : insertarListaPolaca(lPolaca, "@min");
                } else {
                    contLong = 1;
                }
            };
factor: ID {
        char nombre[150] = "_";
        char valor[150];
        sprintf(valor, "%s", $1);
        insertarListaPolaca(lPolaca, strcat(nombre, valor));
        printf("factor ID - Regla 44\n"); }
      | ENTERO {
          printf("factor ENTERO - Regla 45\n");
          char nombre[150] = "_";
          char valor[150];
          sprintf(valor, "%d", $1);
          insertarListaPolaca(lPolaca, strcat(nombre, valor));
          strcat(valor, ".0");
          detectarInsertar(lista, crearDato(nombre, "-", valor, "-")); }
      | REAL {
          printf("factor REAL - Regla 46\n");
          char nombre[150] = "_";
          char valor[150];
          sprintf(valor, "%.4f", $1);
          insertarListaPolaca(lPolaca, strcat(nombre, valor));
          detectarInsertar(lista, crearDato(nombre, "-", valor, "-")); }
      | long {
          printf("factor LONG - Regla 47\n"); };

operador: OP_MAY{
            __operador__comparador = "BLE";
            printf("Operador OP_MAY - Regla 48\n");}
        | OP_MEN{
            __operador__comparador = "BGE";
            printf("Operador OP_MEN - Regla 49\n");}
        | OP_MAY_IGUAL{
            __operador__comparador = "BLT";
            printf("Operador OP_MAY_IGUAL - Regla 50\n");}
        | OP_MEN_IGUAL{
            __operador__comparador = "BGT";
            printf("Operador OP_MEN_IGUAL - Regla 51\n");}
        | OP_IGUALIGUAL{
            __operador__comparador = "BNE";
            printf("Operador OP_IGUALIGUAL - Regla 52\n");}
        | OP_DISTINTO{
            __operador__comparador = "BEQ";
            printf("Operador OP_DISTINTO - Regla 53\n"); };
%%

int main(){
    lista = crearLista();
    listaTipoDato = crearListaSimple();
    listaListaVariables = crearListaSimple();
    listaEqu = crearListaSimple();
    listaIf = crearListaSimple();
    listaIf2 = crearListaSimple();
    listaWhile = crearListaSimple();
    listaWhileInicio = crearListaSimple();
    listaComparacion = crearListaSimple();

    lPolaca = crearListaPolaca();
    yyparse();
    escribirLista(lista);
    escribirListaPolaca(lPolaca);
    generarAssembler("./ts.txt", "./intermedia.txt");
}

void yyerror (char const *s) {
    printf("Programa terminado por error \n");
    exit(1);
}
