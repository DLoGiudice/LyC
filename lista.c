#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Tenemos un puntero a lista, esa lista es de s_nodo, cada nodo tiene
// un t_dato (este t_dato es un struct de dato que tiene los datos
// propio de lo que se desea guardar) y un puntero al siguiente de
// la lista.

// Struct de datos
typedef struct s_dato
{
    char nombre[31];
    char tipo[9];
    char valor[30];
    char longitud[2];
} t_dato;

// Tenemos maxima cadena y ID de 30, se le suma 1 por el /n
typedef struct s_nodo
{
    t_dato *dato;
    struct s_nodo *siguiente;
} t_nodo;

typedef t_nodo *t_lista;

typedef struct lista
{
    t_lista prim;
    t_lista ult;
} listaPPF;

listaPPF* crearLista();
int insertarLista(listaPPF *lista, t_dato *dato);
t_dato *crearDato(char *nombre, char *tipo, char *valor, char *longitud);
int escribirLista(listaPPF *lista);

int escribirLista(listaPPF *lista)
{

    printf ("ESTOY ESCRIBIENDO");
    FILE *fp;

    fp = fopen("ts.txt", "w+");
    if (fp == NULL)
        return 1;

    fprintf(fp, "%s\n", "NOMBRE|TIPODATO|VALOR|LONGITUD");
    printf("NOMBRE|TIPODATO|VALOR|LONGITUD");
    while (lista->prim != NULL)
    {
        t_nodo *nodo = lista->prim;
        t_dato *dato = nodo->dato;

        fprintf(fp, "%s|%s|%s|%s\n", dato->nombre, dato->tipo, dato->valor, dato->longitud);
        printf("%s|%s|%s|%s\n", dato->nombre, dato->tipo, dato->valor, dato->longitud);
        
        lista->prim = lista->prim->siguiente;
        free(nodo);
    }

    fclose(fp);

    return (0);
}

// Si retorna 1 es un error
t_dato* crearDato(char *nombre, char *tipo, char *valor, char *longitud)
{
    t_dato *dato;
    dato = (t_dato *)malloc(sizeof(t_dato));
    printf("Estoy en crearDato");
    if (dato == NULL){
        exit(1);
    }
    strcpy(dato->nombre, nombre);
    strcpy(dato->tipo, tipo);
    strcpy(dato->valor, valor);
    strcpy(dato->longitud, longitud);

    return dato;
}

// Si retorna 1 es un error
int insertarLista(listaPPF *lista, t_dato *dato)
{
    t_nodo *nuevoNodo;
    nuevoNodo = (t_nodo *)malloc(sizeof(t_nodo));
    printf("Estoy en insertarLista");

    if (nuevoNodo == NULL)
    {
        return 1;
    }

    nuevoNodo->dato = dato;
    nuevoNodo->siguiente = NULL;

    if (lista->prim == NULL)
    {
        lista->prim = nuevoNodo;
    }
    else
    {
        lista->ult->siguiente = nuevoNodo;
    }
    lista->ult = nuevoNodo;
}

listaPPF* crearLista()
{   listaPPF *lista;
    lista = (listaPPF *)malloc(sizeof(listaPPF));

    lista->prim = NULL;
    lista->ult = NULL;
}