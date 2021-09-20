#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Tenemos un puntero a lista, esa lista es de s_nodo, cada nodo tiene
// un t_dato (este t_dato es un struct de dato que tiene los datos
// propio de lo que se desea guardar) y un puntero al siguiente de
// la lista.

// Struct de datos
typedef struct s_datoSimple
{
    char datoSimple[31];
} t_datoSimple;

// Tenemos maxima cadena y ID de 30, se le suma 1 por el /n
typedef struct s_nodoSimple
{
    t_datoSimple dato;
    struct s_nodoSimple *siguiente;
} t_nodoSimple;

typedef t_nodoSimple *t_listaSimple;

typedef struct listaS
{
    t_listaSimple prim;
    t_listaSimple ult;
} listaSimple;

listaSimple *crearListaSimple();
int insertarListaSimple(listaSimple *lista, char * cadena);
int escribirListaSimple(listaSimple *listaVariables, listaSimple * listaTipos);

// Si retorna 1 es un error
int insertarListaSimple(listaSimple *lista, char * cadena)
{
    t_nodoSimple *nuevoNodo;
    t_datoSimple dato;

    nuevoNodo = (t_nodoSimple *)malloc(sizeof(t_nodoSimple));
    if (nuevoNodo == NULL)
        return 1;

    strcpy(dato.datoSimple, cadena);
    nuevoNodo->dato = dato;
    nuevoNodo->siguiente = NULL;

    if (lista->prim == NULL)
        lista->prim = nuevoNodo;
    else
        lista->ult->siguiente = nuevoNodo;

    lista->ult = nuevoNodo;
    return 0;
}

listaSimple *crearListaSimple()
{
    listaSimple *lista;
    lista = (listaSimple *)malloc(sizeof(listaSimple));

    lista->prim = NULL;
    lista->ult = NULL;
    return lista;
}