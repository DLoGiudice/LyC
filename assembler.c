#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "helpers.h"

int generarAssembler(char *, char *);
void imprimirEncabezado(FILE *);
void imprimirCodigoEstaticoCuerpo(FILE *);
void imprimirCodigoIntermedio(FILE *, FILE *);
void imprimirSenialDeFin(FILE *);
void imprimirTablaDeSimbolos(FILE *, FILE *);
void guardarSimbolo(char *, char *, FILE *);
void contructorConstantes(char *, char *);
int esOperando(char *);
char * limpiarStringLeido(char *);


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

    while(!feof(archivoIntermedia)) {
        fgets(linea,tam_char,archivoIntermedia);
        
        stringLeido = strrchr(linea, delimitador);
        stringLeido = limpiarStringLeido(stringLeido);

        if (esOperando(stringLeido) == 1) {
            printf("SOY OPERANDO WIII!\n");
            // desapilar 1 si es unitario
            // desapilar 2 si es binario
        } else {
            printf("soy operador =(\n");
            // Apilar
        }
    }
}

int esOperando(char * stringLeido){
    // Array de Strings = Matriz de chars
    int cantidadDeOperandos = 1; // Actualizar a medida que incorporamos operandos
    int longitudOperando = 100; 
    char operandos[1][100] = {"OP_ASIG"}; // Agregar operandos
    int encontrado = 0;
    
    for(int i=0; i<cantidadDeOperandos; i++)
    {
        if(strcmp(operandos[i], stringLeido) == 0)
        {
            encontrado = 1;
            break;
        }
    }

    return encontrado;
}

char * limpiarStringLeido(char * cadena) {
    // Elimino "-" y espacio restante
    cadena++; 
    eliminarEspacios(cadena);
    
    // Elimino \n del final
    cadena[strlen(cadena) - 1] = 0;
    return cadena;
}

