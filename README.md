# Lenguajes y Compiladores - Grupo 8

## Bienvenido al Trabajo Practico de Lenguajes y Compiladores del **Grupo 8**.
## La entrega final se encuentra en el tag v3.0
### Guia de Instalacion
1. Clonar el repositorio en un directorio de preferencia.  
`git clone -b main https://github.com/DLoGiudice/LyC.git`
2. Ir al directorio y correr el script con el siguiente código:  
`.\grupo08.bat`
3. Luego de correr el script, en el archivo **ts.txt** se encontrará la tabla de simbolos.
4. Luego de correr el script, en el archivo **intermedia.txt** se encontrará la intermedia.
5. Luego de correr el script, en el archivo **final.asm** se encontrará el codigo assembler.

> El script borrará todos los archivos intermedios generados (y.tab.c, y.tab.h, y.output, lex.y.C)

### Instrucciones de uso - Sin compilar.

Si no se desea correr el script para realizar la compilación, dentro del repositorio encontrará el archivo `grupo08.exe` con el compilador ya listo para ser utilizado.

El mismo podra ser utilizado de la siguiente manera desde Windows: `type {nombre_de_archivo_de_pruebas} | grupo08.exe`.

En este repositorio se encuentra un archivo de pruebas generico `pruebas.txt` que recorré cada una de las reglas. El mismo podra ser utilizado de la siguiente manera: `type pruebas.txt | grupo08.exe`


