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
//t_dato crearDato(char *nombre, char *tipo, char *valor, char *longitud);
 int escribirListaSimple(listaSimple *listaVariables, listaSimple * listaTipos);
// int detectarDuplicados(listaPPF *lista, t_dato dato);
// int detectarInsertar(listaPPF *lista, t_dato dato);

// Si devuelve un 1 fallo por que hay un duplicado
// int detectarInsertar(listaPPF *lista, t_dato dato)
// {
//     if (detectarDuplicados(lista, dato) == 0)
//     {
//         insertarLista(lista, dato);
//         return 0;
//     }
//     else
//     {
//         return 1;
//     }
// }

int escribirListaSimple(listaSimple *listaVariables, listaSimple * listaTipos)
{
    printf("Fuera while ESCRIBIENDO LISTA SIMPLE \n");

    while (listaVariables->prim != NULL)
    {
        t_nodoSimple *nodoVariables = listaVariables->prim;
        t_datoSimple datoVariables = nodoVariables->dato;

        t_nodoSimple *nodoTipos = listaTipos->prim;
        t_datoSimple datoTipos = nodoTipos->dato;

       // fprintf(fp, "%s|%s|%s|%s\n", dato.nombre, dato.tipo, dato.valor, dato.longitud);
        printf("ESCRIBIENDO LISTA SIMPLE \n");
        printf("%s|%s\n", datoVariables.datoSimple, datoTipos.datoSimple);

        listaVariables->prim = listaVariables->prim->siguiente;
        listaTipos->prim = listaTipos->prim->siguiente;
        free(nodoVariables);
        free(nodoTipos);
    }

    return (0);
}

// // Si retorno un 1 hay un duplicado
// // Uso un auxiliar para no mover lista y que quede siempre apuntando al 1°
// int detectarDuplicados(listaPPF *lista, t_dato dato)
// {
//     t_nodo *auxiliar;
//     auxiliar = lista->prim;
//     while (auxiliar != NULL)
//     {
//         if (strcmp(auxiliar->dato.nombre, dato.nombre) == 0)
//         {
//             // esta en la lista de simbolos
//             return 1;
//         }
//         auxiliar = auxiliar->siguiente;
//     }
//     return 0;
// }

// Si retorna 1 es un error
// t_dato crearDato(char *nombre, char *tipo, char *valor, char *longitud)
// {
//     t_dato dato;

//     strcpy(dato.nombre, nombre);
//     strcpy(dato.tipo, tipo);
//     strcpy(dato.valor, valor);
//     strcpy(dato.longitud, longitud);

//     return dato;
// }

// Si retorna 1 es un error
int insertarListaSimple(listaSimple *lista, char * cadena)
{
    t_nodoSimple *nuevoNodo;
    nuevoNodo = (t_nodoSimple *)malloc(sizeof(t_nodoSimple));
   printf("Estoy en insertarListaSIMPLEEEEEEE");


        t_datoSimple dato;

     strcpy(dato.datoSimple, cadena);

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

listaSimple *crearListaSimple()
{
    listaSimple *lista;
    lista = (listaSimple *)malloc(sizeof(listaSimple));

    lista->prim = NULL;
    lista->ult = NULL;
}