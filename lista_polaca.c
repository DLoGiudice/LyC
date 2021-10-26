#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Tenemos un puntero a lista, esa lista es de s_nodo, cada nodo tiene
// un t_dato (este t_dato es un struct de dato que tiene los datos
// propio de lo que se desea guardar) y un puntero al siguiente de
// la lista.

// Struct de datos
typedef struct s_datoPolaca {
    char datoPolaca[31];
}
t_datoPolaca;

// Tenemos maxima cadena y ID de 30, se le suma 1 por el /n
typedef struct s_nodoPolaca {
    t_datoPolaca dato;
    struct s_nodoPolaca * siguiente;
}
t_nodoPolaca;

typedef t_nodoPolaca * t_listaPolaca;

typedef struct listaP {
    t_listaPolaca prim;
    t_listaPolaca ult;
}
listaPolaca;

listaPolaca * crearListaPolaca();
int insertarListaPolaca(listaPolaca * lista, char * cadena);
int celdaActual(listaPolaca * lista);
int insertarListaPolacaCeldaEspecifica(listaPolaca * lista, char * cadena, char * posicion);
int printListaPolaca(listaPolaca * lista);

// Si retorna 1 es un error
int insertarListaPolaca(listaPolaca * lista, char * cadena) {
    t_nodoPolaca * nuevoNodo;
    t_datoPolaca dato;

    nuevoNodo = (t_nodoPolaca * ) malloc(sizeof(t_nodoPolaca));
    if (nuevoNodo == NULL)
        return 1;
        
    strcpy(dato.datoPolaca, cadena);
    nuevoNodo -> dato = dato;
    nuevoNodo -> siguiente = NULL;

    if (lista -> prim == NULL)
        lista -> prim = nuevoNodo;
    else
        lista -> ult -> siguiente = nuevoNodo;
    lista -> ult = nuevoNodo;
    return 0;
}

int insertarListaPolacaNodoEspecifica(listaPolaca * lista, char * cadena, char * posicion) {
    t_nodoPolaca * auxiliar;
    int celdaActual = 0;
    int posicionInt = 0;

    auxiliar = lista -> prim;
    posicionInt = atoi(posicion);
    posicionInt = posicionInt -1;
    while (celdaActual != posicionInt) {
        auxiliar = auxiliar -> siguiente;
        celdaActual++;
    }

    strcpy(auxiliar -> dato.datoPolaca, cadena);

    return 1;
}

int escribirListaPolaca(listaPolaca * lista) {
    FILE * fp;
    int con = 1;

    fp = fopen("intermedia.txt", "w+");
    if (fp == NULL)
        return 1;

    while (lista -> prim != NULL) {
        t_nodoPolaca * nodo = lista -> prim;
        t_datoPolaca dato = nodo -> dato;
        fprintf(fp, "%d - %s \n", con, dato.datoPolaca);
        lista -> prim = lista -> prim -> siguiente;
        free(nodo);
        con ++;
    }
    fclose(fp);
    return 0;
}

listaPolaca * crearListaPolaca() {
    listaPolaca * lista;
    lista = (listaPolaca * ) malloc(sizeof(listaPolaca));
    lista -> prim = NULL;
    lista -> ult = NULL;
    return lista;
}


int celdaActual(listaPolaca * lista) {
    int celdaActual = 0;
    t_nodoPolaca * auxiliar;

    auxiliar = lista -> prim;
    while (auxiliar != NULL) {
        auxiliar = auxiliar -> siguiente;
        celdaActual++;
    }

    return celdaActual + 1;
}

int printListaPolaca(listaPolaca * lista) {
    int con = 1;
    t_nodoPolaca * auxiliar;

    auxiliar = lista -> prim;
    while (auxiliar != NULL) {
        printf("%d - %s \n", con, auxiliar -> dato.datoPolaca);
        auxiliar = auxiliar -> siguiente;
        con ++;
    }
    return 0;
}