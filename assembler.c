#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int generarAssembler(char *, char *);
void imprimirEncabezado(FILE *);
void imprimirTablaDeSimbolos(FILE *, FILE *);
void guardarSimbolo(char *, char *, FILE *);
void eliminar_espacios(char *);


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
    // imprimirCodigoEstaticoCuerpo()
    // imprimirCodigoIntermedio()
    // imprimirSenialDeFin()

    fclose(archivoTablaDeSimbolos);
    fclose(archivoIntermedia);
    fclose(archivoAssembler);
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
        eliminar_espacios(linea);

        // Salteo las primeras dos lineas de encabezado.
        // Pura mantenibilidad y flexibilidad. Calida'
        if (lineas_encabezado < 2) {
            lineas_encabezado++;
            continue;
        }
        
        guardarSimbolo(linea, delimitador, archivo);
    }
}

void guardarSimbolo(char * linea, char * delimitador, FILE * archivo) {
    // Uso de strtok --> https://www.codingame.com/playgrounds/14213/how-to-play-with-strings-in-c/string-split
    char *ptr = strtok(linea, delimitador);
    int cont_columnas = 0;
    char * simbolo;
    char * valor;

    while(ptr != NULL)
	{
        if (cont_columnas == 0) {
            simbolo = ptr;
        }

        if (cont_columnas == 2) {
            valor = ptr;
        }

        if (cont_columnas == 3) {
            fprintf(archivo, "%-30s | dd | %-10s\n", simbolo, valor);
            cont_columnas = 0;
        }

        cont_columnas++;
		ptr = strtok(NULL, delimitador);
	}
}

void eliminar_espacios(char* s) {
    // https://stackoverflow.com/questions/1726302/remove-spaces-from-a-string-in-c
    char* d = s;
    do {
        while (*d == ' ') {
            ++d;
        }
    } while (*s++ = *d++);
}






