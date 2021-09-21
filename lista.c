#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lista_simple.c"

// Tenemos un puntero a lista, esa lista es de s_nodo, cada nodo tiene
// un t_dato (este t_dato es un struct de dato que tiene los datos
// propio de lo que se desea guardar) y un puntero al siguiente de
// la lista.

// Struct de datos
typedef struct s_dato {
    char nombre[31];
    char tipo[9];
    char valor[30];
    char longitud[2];
}
t_dato;

// Tenemos maxima cadena y ID de 30, se le suma 1 por el /n
typedef struct s_nodo {
    t_dato dato;
    struct s_nodo * siguiente;
}
t_nodo;

typedef t_nodo * t_lista;

typedef struct lista {
    t_lista prim;
    t_lista ult;
}
listaPPF;

listaPPF * crearLista();
int insertarLista(listaPPF * lista, t_dato dato);
t_dato crearDato(char * nombre, char * tipo, char * valor, char * longitud);
int escribirLista(listaPPF * lista);
int detectarDuplicados(listaPPF * lista, t_dato dato);
int detectarInsertar(listaPPF * lista, t_dato dato);
int escribirPares(listaPPF * lista, listaSimple * listaVariables, listaSimple * listaTipos);

// Si devuelve un 1 fallo por que hay un duplicado
int escribirPares(listaPPF * lista, listaSimple * listaVariables, listaSimple * listaTipos) {
    while (listaVariables -> prim != NULL) {
        t_nodoSimple * nodoVariables = listaVariables -> prim;
        t_datoSimple datoVariables = nodoVariables -> dato;
        t_nodoSimple * nodoTipos = listaTipos -> prim;
        t_datoSimple datoTipos = nodoTipos -> dato;

        if (detectarInsertar(lista, crearDato(datoVariables.datoSimple, datoTipos.datoSimple, "-", "-")) == 1)
            return 1;
        listaVariables -> prim = listaVariables -> prim -> siguiente;
        listaTipos -> prim = listaTipos -> prim -> siguiente;
        free(nodoVariables);
        free(nodoTipos);
    }
    return 0;
}

// Si devuelve un 1 fallo por que hay un duplicado
int detectarInsertar(listaPPF * lista, t_dato dato) {
    if (detectarDuplicados(lista, dato) == 0) {
        insertarLista(lista, dato);
        return 0;
    } else {
        return 1;
    }
}

int escribirLista(listaPPF * lista) {
    FILE * fp;

    fp = fopen("ts.txt", "w+");
    if (fp == NULL)
        return 1;

    fprintf(fp, "%-30s|%-10s|%-10s|%-16s\n", "NOMBRE", "TIPODATO", "VALOR", "LONGITUD");
    fprintf(fp, "%s\n", "==================================================================");
    while (lista -> prim != NULL) {
        t_nodo * nodo = lista -> prim;
        t_dato dato = nodo -> dato;
        fprintf(fp, "%-30s|%-10s|%-10s|%-16s\n", dato.nombre, dato.tipo, dato.valor, dato.longitud);
        lista -> prim = lista -> prim -> siguiente;
        free(nodo);
    }

    fclose(fp);
    return 0;
}

// Si retorno un 1 hay un duplicado
// Uso un auxiliar para no mover lista y que quede siempre apuntando al 1°
int detectarDuplicados(listaPPF * lista, t_dato dato) {
    t_nodo * auxiliar;
    auxiliar = lista -> prim;
    while (auxiliar != NULL) {
        if (strcmp(auxiliar -> dato.nombre, dato.nombre) == 0) {
            // esta en la lista de simbolos
            return 1;
        }
        auxiliar = auxiliar -> siguiente;
    }
    return 0;
}

// Si retorna 1 es un error
t_dato crearDato(char * nombre, char * tipo, char * valor, char * longitud) {
    t_dato dato;
    strcpy(dato.nombre, nombre);
    strcpy(dato.tipo, tipo);
    strcpy(dato.valor, valor);
    strcpy(dato.longitud, longitud);
    return dato;
}

// Si retorna 1 es un error
int insertarLista(listaPPF * lista, t_dato dato) {
    t_nodo * nuevoNodo;
    nuevoNodo = (t_nodo * ) malloc(sizeof(t_nodo));
    printf("Estoy en insertarLista");

    if (nuevoNodo == NULL)
        return 1;

    nuevoNodo -> dato = dato;
    nuevoNodo -> siguiente = NULL;

    if (lista -> prim == NULL)
        lista -> prim = nuevoNodo;
    else
        lista -> ult -> siguiente = nuevoNodo;
    lista -> ult = nuevoNodo;
    return 0;
}

listaPPF * crearLista() {
    listaPPF * lista;
    lista = (listaPPF * ) malloc(sizeof(listaPPF));
    lista -> prim = NULL;
    lista -> ult = NULL;
    return lista;
}