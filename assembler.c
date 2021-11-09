#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "helpers.h"

#define CANT_OPERANDOS 9
#define LONG_OPERANDOS 100
#define CANT_INSTRUCCIONES 4

int generarAssembler(char *, char *);
void imprimirEncabezado(FILE *);
void imprimirCodigoEstaticoCuerpo(FILE *);
void imprimirCodigoIntermedio(FILE *, FILE *);
void imprimirSenialDeFin(FILE *);
void imprimirTablaDeSimbolos(FILE *, FILE *);

void escribirAssembler(FILE *, char *, int *);

void guardarSimbolo(char *, char *, FILE *);
void contructorConstantes(char *, char *);
int esOperador(char [CANT_OPERANDOS][LONG_OPERANDOS], char *);
char * limpiarStringLeido(char *);
int escribirBinario(FILE *, char *, char *, char *, int *, listaSimple *);
void buscarInstruccion(char *, char *);


int generarAssembler(char * tablaDeSimbolos, char * intermedia) {
    FILE* archivoTablaDeSimbolos = fopen(tablaDeSimbolos, "r" );
    FILE* archivoIntermedia = fopen(intermedia, "r" );
    FILE* archivoAssembler = fopen("assm.asm", "w");

    if (archivoTablaDeSimbolos == NULL) {
        return 1;
    }

    if (archivoIntermedia == NULL) {
        return 1;
    }

    if (archivoAssembler == NULL) {
        return 1;
    }

    // Paso a Paso
    imprimirEncabezado(archivoAssembler);
    imprimirTablaDeSimbolos(archivoAssembler, archivoTablaDeSimbolos);
    imprimirCodigoEstaticoCuerpo(archivoAssembler);
    imprimirCodigoIntermedio(archivoAssembler, archivoIntermedia);
    imprimirSenialDeFin(archivoAssembler);

    fclose(archivoTablaDeSimbolos);
    fclose(archivoIntermedia);
    fclose(archivoAssembler);
}

void imprimirEncabezado(FILE * archivo) {
    fprintf(archivo, "include macros2.asm\n");
    fprintf(archivo, "include number.asm\n\n");
    fprintf(archivo, ".MODEL SMALL\n");
    fprintf(archivo, ".386\n");
    fprintf(archivo, ".STACK 200h\n\n");
}

void imprimirCodigoEstaticoCuerpo(FILE * archivo){
    fprintf(archivo, "\n");
    fprintf(archivo, ".CODE\n");
    fprintf(archivo, "mov\tAX,@DATA\n");
    fprintf(archivo, "mov\tDS,AX\n");
    fprintf(archivo, "mov\tes,ax\t;\n\n");    
}

void imprimirSenialDeFin(FILE * archivo){
    fprintf(archivo, "\n");
    fprintf(archivo, "mov\tah, 1 ; pausa, espera que oprima una tecla\n");
    fprintf(archivo, "int\t21h ; AH=1 es el servicio de lectura\n");
    fprintf(archivo, "mov\tax,4c00h ; Sale del Dos\n");
    fprintf(archivo, "int\t21h ; Enviamos la interripcion 21h\n");
    fprintf(archivo, "\n");
    fprintf(archivo, "End\n\n");
}


void imprimirTablaDeSimbolos(FILE * archivo, FILE * tablaDeSimbolos) {
    int tam_char = 150;
    char linea[tam_char];
    int lineas_encabezado = 0;
    char simbolo[32];
    char * delimitador = "|";
    int indice;

    fprintf(archivo, ".DATA\n\n");

    fgets(linea,tam_char,tablaDeSimbolos);
    fgets(linea,tam_char,tablaDeSimbolos);
    fgets(linea,tam_char,tablaDeSimbolos);

    while(!feof(tablaDeSimbolos)) {
        eliminarEspacios(linea);        
        guardarSimbolo(linea, delimitador, archivo);
        fgets(linea,tam_char,tablaDeSimbolos);
    }

    // imprimo AUX
    for(indice=0; indice < 10; indice++) {
        fprintf(archivo, "@aux%d\tdd\t?\n", indice);
    }
}

void guardarSimbolo(char * linea, char * delimitador, FILE * archivo) {
    // Uso de strtok --> https://www.codingame.com/playgrounds/14213/how-to-play-with-strings-in-c/string-split
    char *ptr = strtok(linea, delimitador);
    int cont_columnas = 0;
    char * simbolo;
    char * valor;
    int flagString = 0;

    while(ptr != NULL)
	{
        if (cont_columnas == 0) {
            simbolo = ptr;
        }

        if (cont_columnas == 1) {
            valor = ptr;
            if (strcmp(valor,"CTE_STRING")==0){
                flagString = 1;
            }
        }

        if (cont_columnas == 2) {
            valor = ptr;
        }

        if (cont_columnas == 3) {
            if (strcmp(valor,"-") == 0)
                valor = "?";

            if (flagString == 1 && strcmp(valor,"?") != 0){
                char cadena[100] = "";
                contructorConstantes(cadena, valor);
                strcpy(valor,cadena);
            }

            fprintf(archivo, "%s\tdd\t%s\n", simbolo, valor);
            cont_columnas = 0;
        }

        cont_columnas++;
		ptr = strtok(NULL, delimitador);
	}
}

void escribirAssembler(FILE *archivo, char * valor, int *nroAuxiliar){
        fprintf(archivo, "FLD\t%s\n", valor);
        fprintf(archivo, "FSTP\t@aux%d\n", *nroAuxiliar);
}

void contructorConstantes(char * cadena, char * s){
   // _Ingreseun    db    "Ingrese un",'$', 10 dup (?)
    char *aux1 = ",'$', ";
    char *aux2 = " dup (?)";
    char lenString[2];
    //Resto 2 por las comillas
    int len = strlen(s) - 2;

    sprintf(lenString, "%d", len);
    strcat(cadena,s);
    strcat(cadena,aux1);
    strcat(cadena,lenString);
    strcat(cadena,aux2);
}

void imprimirCodigoIntermedio(FILE * output, FILE * archivoIntermedia) {
    int tam_char = 150;
    char linea[tam_char];
    char * stringLeido;
    int delimitador = '-'; // Necesita comillas simples para funcionar
    char operadores[CANT_OPERANDOS][LONG_OPERANDOS] = {"OP_ASIG", "OP_MAS", "OP_MUL", "OP_DIV", "OP_MENOS", "GET", "DISPLAY", "NOT", "AS"}; // Agregar operandos
    int operandor_paridad[CANT_OPERANDOS] = {1, 1, 1, 1, 1, 0, 0, 0, 0}; // Agregar operandos
    int indice_operador;
    char valorDesapilado_1[LONG_OPERANDOS];
    char valorDesapilado_2[LONG_OPERANDOS];
    int nroAuxiliar = 0;

    listaSimple *lista;
    lista = crearListaSimple();

    fgets(linea, tam_char, archivoIntermedia);

    while(!feof(archivoIntermedia)) {
        stringLeido = strrchr(linea, delimitador);
        stringLeido = limpiarStringLeido(stringLeido);

        indice_operador = esOperador(operadores,stringLeido);

        // Cuando agarramos un operando (ejemplo 12) agregamos un FLD adelante y abajo escribimos un
        // FSTP con un @auxN (N -> numero). LO QUE SE VA A PILANDO SON LOS AUXILIARES, SIEMPRE QUE SE
        // HAGA UNA OPERACION SE CREA UN AUXILIAR Y SE APILA EL MISMO.
        // Cuando viene un operador (op_mas) se desapilan 2 o 1 (segundo binario o unario) y se opera
        // CON LOS AUXILIARES!!!! y el resultado se APILA en un nuevo axilar 

        if (indice_operador != -1) {
            if(operandor_paridad[indice_operador] == 0){
                // desapilarDeLista(lista, valorDesapilado_1);
                // SOy un unario
            }
            else{
                desapilarDeLista(lista, valorDesapilado_1);

                if(strcmp(operadores[indice_operador], "OP_ASIG") == 0) {
                    fprintf(output, "FLD\t%s\n", valorDesapilado_1);
                    fgets(linea, tam_char, archivoIntermedia);
                    stringLeido = strrchr(linea, delimitador);
                    stringLeido = limpiarStringLeido(stringLeido);
                    fprintf(output, "FSTP\t%s\n", stringLeido);
                    fprintf(output, "FFREE\n");
                } else {
                    desapilarDeLista(lista, valorDesapilado_2);
                    // OP_SUM 12, 78
                    escribirBinario(output, operadores[indice_operador], valorDesapilado_1, valorDesapilado_2,  &nroAuxiliar, lista);
                    nroAuxiliar = nroAuxiliar + 1;  
                    // funcion que le paso el operador y los 2 operandos y se encarga de hacer lo que debe,
                    // es decir, escribir en el assm.txt
                }
            }

        } else {
            char aux[10]= "@aux";
            char numero[5];
            
            sprintf(numero, "%d", nroAuxiliar);
            strcat(aux, numero);
            insertarListaSimple(lista, aux);
            escribirAssembler(output, stringLeido, &nroAuxiliar);
            nroAuxiliar = nroAuxiliar + 1;
        }

        fgets(linea, tam_char, archivoIntermedia);
    }
}

int escribirBinario(FILE * archivo, char * operando, char * valor1, char * valor2, int * nroAuxiliar, listaSimple * lista){
    char instruccionAssembler[150];
    char aux[10]= "@aux";
    char numero[5];           
    
    fprintf(archivo, "FLD\t%s\n", valor2);
    fprintf(archivo, "FLD\t%s\n", valor1);

    buscarInstruccion(operando, instruccionAssembler);
    fprintf(archivo, "%s\n", instruccionAssembler);

    sprintf(numero, "%d", *nroAuxiliar);
    strcat(aux, numero);

    insertarListaSimple(lista, aux);

    fprintf(archivo, "FSTP\t@aux%d\n", *nroAuxiliar);
}

int esOperador(char operandos[CANT_OPERANDOS][LONG_OPERANDOS], char * stringLeido){
    // Array de Strings = Matriz de chars
    int indice;
    for(indice=0; indice < CANT_OPERANDOS; indice++)
        if(strcmp(operandos[indice], stringLeido) == 0){
            return indice;
            }
    return -1;
}

char * limpiarStringLeido(char * cadena) {
    // Elimino "-" y espacio restante
    cadena++; 
    eliminarEspacios(cadena);
    
    // Elimino \n del final
    cadena[strlen(cadena) - 1] = 0;
    return cadena;
}

void buscarInstruccion(char * operando, char * instruccionAssembler){
    char operadores[CANT_INSTRUCCIONES][LONG_OPERANDOS] = {"OP_MAS", "OP_MUL", "OP_DIV", "OP_MENOS"}; // Agregar operandos
    char instrucciones[CANT_INSTRUCCIONES][LONG_OPERANDOS] = {"FADD", "FMUL", "FDIV", "FSUB"}; // Agregar operandos
    int i;

    for(i=0; i < CANT_INSTRUCCIONES; i++) {
        if(strcmp(operadores[i], operando) == 0) {
            strcpy(instruccionAssembler, instrucciones[i]);
            return;
        }
    }

    return;
}