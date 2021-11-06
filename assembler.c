#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "helpers.h"

#define CANT_OPERANDOS 7
#define LONG_OPERANDOS 100

int generarAssembler(char *, char *);
void imprimirEncabezado(FILE *);
void imprimirCodigoEstaticoCuerpo(FILE *);
void imprimirCodigoIntermedio(FILE *, FILE *);
void imprimirSenialDeFin(FILE *);
void imprimirTablaDeSimbolos(FILE *, FILE *);
void guardarSimbolo(char *, char *, FILE *);
void contructorConstantes(char *, char *);
int esOperador(char [CANT_OPERANDOS][LONG_OPERANDOS], char *);
char * limpiarStringLeido(char *);
int esUnario (char*);
int escribirBinario(char *, char *, char *);


int generarAssembler(char * tablaDeSimbolos, char * intermedia) {
    FILE* archivoTablaDeSimbolos = fopen(tablaDeSimbolos, "r" );
    FILE* archivoIntermedia = fopen(intermedia, "r" );
    FILE* archivoAssembler = fopen("assm.txt", "w");

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

void imprimirSenialDeFin(FILE * archivo){
    fprintf(archivo, "\n");
    fprintf(archivo, "mov\tax,4c00h\n");
    fprintf(archivo, "int\t21h\n");
    fprintf(archivo, "\n");
    fprintf(archivo, "End\n\n");    
}

void imprimirCodigoEstaticoCuerpo(FILE * archivo){
    fprintf(archivo, "\n");
    fprintf(archivo, "CODE\n");
    fprintf(archivo, "mov\tAX,@DATA\n");
    fprintf(archivo, "mov\tDS,AX\n");
    fprintf(archivo, "mov\tes,ax\t;\n\n");    
}

void imprimirEncabezado(FILE * archivo) {
    fprintf(archivo, ".MODEL LARGE\n");
    fprintf(archivo, ".386\n");
    fprintf(archivo, ".STACK 200h\n\n");
}

void imprimirTablaDeSimbolos(FILE * archivo, FILE * tablaDeSimbolos) {
    int tam_char = 150;
    char linea[tam_char];
    int lineas_encabezado = 0;
    char simbolo[32];
    char * delimitador = "|";

    fprintf(archivo, ".DATA\n\n");

    while(!feof(tablaDeSimbolos)) {
        fgets(linea,tam_char,tablaDeSimbolos);
        eliminarEspacios(linea);

        // Salteo las primeras dos lineas de encabezado.
        // Pura mantenibilidad y flexibilidad. Calida'
        if (lineas_encabezado < 2) {
            lineas_encabezado++;
            continue;
        }
        
        
       // printf("GUARDAR SIMBOLOS");
        
        guardarSimbolo(linea, delimitador, archivo);
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
            printf("CTE_STRING %s ", valor);
            if (strcmp(valor,"CTE_STRING")==0){
                printf("CTE_STRING");
                flagString = 1;
            }
        }

        if (cont_columnas == 2) {
            // Pasar valor a float si es Int
            // Para usar el copro sin problemas.
            valor = ptr;
        }

        if (cont_columnas == 3) {
            if (strcmp(valor,"-") == 0)
                valor = "?";

            if (flagString == 1 && strcmp(valor,"?") != 0){
                char cadena[100] = "";
                contructorConstantes(cadena, valor);
                strcpy(valor,cadena);
                printf ("VALOR: %s", cadena);
            }

            fprintf(archivo, "%s\tdd\t%s\n", simbolo, valor);
            cont_columnas = 0;
        }

        cont_columnas++;
		ptr = strtok(NULL, delimitador);
	}
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
    char operadores[CANT_OPERANDOS][LONG_OPERANDOS] = {"OP_ASIG", "OP_MAS", "OP_MUL", "GET", "DISPLAY", "NOT", "AS"}; // Agregar operandos
    int operandor_paridad[CANT_OPERANDOS] = {1, 1, 1, 0, 0, 0, 0}; // Agregar operandos
    int indice_operador;
    char valorDesapilado_1[LONG_OPERANDOS];
    char valorDesapilado_2[LONG_OPERANDOS];

    listaSimple *lista;
    lista = crearListaSimple();

    while(!feof(archivoIntermedia)) {
        fgets(linea, tam_char, archivoIntermedia);
        
        stringLeido = strrchr(linea, delimitador);
        stringLeido = limpiarStringLeido(stringLeido);

        indice_operador = esOperador(operadores,stringLeido);
        printf("\nindice_operador, %d", indice_operador);

        // Cuando agarramos un operando (ejemplo 12) agregamos un FLD adelante y abajo escribimos un
        // FSTP con un @auxN (N -> numero). LO QUE SE VA A PILANDO SON LOS AUXILIARES, SIEMPRE QUE SE
        // HAGA UNA OPERACION SE CREA UN AUXILIAR Y SE APILA EL MISMO.
        // Cuando viene un operador (op_mas) se desapilan 2 o 1 (segundo binario o unario) y se opera
        // CON LOS AUXILIARES!!!! y el resultado se APILA en un nuevo axilar 




        if (indice_operador != -1) {

            if(operandor_paridad[indice_operador] == 0){
                desapilarDeLista(lista, valorDesapilado_1);
                
                printf("_VALOR DESAPILADO %s", valorDesapilado_1);
                // SOy un unario
            }
            else{
                desapilarDeLista(lista, valorDesapilado_1);
                printf("___VALOR DESAPILADO %s", valorDesapilado_1);
                desapilarDeLista(lista, valorDesapilado_2);
                printf("___VALOR DESAPILADO %s", valorDesapilado_2);

                // OP_SUM 12, 78
                escribirBinario(operadores[indice_operador], valorDesapilado_1, valorDesapilado_2);

                // funcion que le paso el operador y los 2 operandos y se encarga de hacer lo que debe,
                // es decir, escribir en el assm.txt
            }

        } else {
            printf("soy operando =(\n");
            printf("Estoy insertando, %s\n", stringLeido);
            insertarListaSimple(lista, stringLeido);

            // Apilar
        }
    }
}

int escribirBinario(char * operando, char * valor1, char * valor2){
    printf("\n\n\nESCRIBIR BINARIO\n");
    printf("VAlor operando %s\n", operando);
    printf("VAlor valor1 %s\n", valor1);
    printf("VAlor valor2 %s\n", valor2);

       

}

int esUnario (char* operador){

    if(strcmp(operador,"GET"))
        return 1;
    
    if(strcmp(operador,"DISPLAY"))
        return 1;

    if(strcmp(operador,"NOT"))
        return 1;

    if(strcmp(operador,"AS"))
        return 1;
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

