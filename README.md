# LyC

* Pila para ingresar el valor y el tipo en dim (Done, no se implemento dos pilas, sino se tomo el codigo que se tenia para lista, se copio y se renombro como lista simple, con un nodo que solo permite insertar una cadena. Se crearon dos listas, una llamada  listaTipoDato y listaListaVariables. Estas listas son listas parelelas donde se van guardando los tipos de datos y las variables. Hay un metodo en lista_simple.c que muestra por pantalla lo insertado y esto lo hace bien. Hay uqe llevar ese metodo a lista y que vaya sacando de las 2 listas nuevas y escribiendo en la ts.)
* Limites de los valores reales 
* Arreglar la redex de los reales, se rompe con .1234 (Done, se agrego un "?", probar a fondo).
* Archivo con ejemplo.
* Numero a las reglas.
* Escritura de la tabla de simbolos. (Done)
* Todo con _ adelante (Done)

Actualizacion 2021-09-18

* Limites de los valores reales (hay una version pero se puede mejorar)
* Archivo con ejemplos.
* Numero a las reglas.

Actualizacion 2021-09-20
* Limites de los valores reales (hay una version pero se puede mejorar)
* Numero a las reglas.
* No le gusta la sintaxis del WHILE.
* No le gusta la sintaxis del LONG.
* No se puede poner:
  > var1 := 3  
  > var2 := 3  
  > No le gusta que hayan dos variables con el mismo valor.  
  > Devuelve simbolo duplicado
