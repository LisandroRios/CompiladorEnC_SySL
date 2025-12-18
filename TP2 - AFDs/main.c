#include <stdio.h> // manejo de archivos y consola
#include <stdlib.h> // Funciones Generales 
#include <ctype.h> // analisis de caracteres (aunque aca no se usa directamente)

// Definicion de Constantes
// El AFD tiene 7 estados (Q0 a QE) y 6 clases de caracteres (0, 1-7, 8-9, xX, a-fA-F, y “otro”).
#define ESTADOS 7
#define CLASES 6

// Estados
// Sirve para trabajar con nombres legibles en lugar de números.
#define Q0 0
#define Q1 1
#define Q2 2
#define Q3 3
#define Q4 4
#define Q5 5
#define QE 6 // estado de error

// Función para clasificar caracteres EXPLICAR MEJOR 
/** 
 * Esta función asigna una clase (columna de la tabla de transiciones) según el carácter.
Ejemplo:
 '3' → clase 1
 'A' → clase 4
 'x' → clase 3
 */
int claseCaracter(int c) {
    if (c == '0') return 0;
    if (c >= '1' && c <= '7') return 1;
    if (c >= '8' && c <= '9') return 2;
    if (c == 'x' || c == 'X') return 3;
    if ((c >= 'a' && c <= 'f') || (c >= 'A' && c <= 'F')) return 4;
    return 5; // cualquier otro
}

// Recibe parámetros de línea de comandos.
// argc es la cantidad de argumentos, argv es el vector que los contiene.
int main(int argc, char *argv[]) {
    if (argc < 2) { // validacion de Parametros 
        printf("Uso: %s archivo.txt\n", argv[0]); // Si no se pasa un archivo, muestra el mensaje de uso.
        return 1;
    }

    // Apertura del archivo
    FILE *f = fopen(argv[1], "r"); // Abre el archivo recibido (constantes.txt) en modo lectura.
    if (!f) {
        printf("No se pudo abrir el archivo %s\n", argv[1]);
        return 1;
    }

// Matriz de transiciones 
/**
 * Representa exactamente el autómata de AFD.dot y README.md.
 * Cada fila = estado actual.
 * Cada columna = clase de carácter.
 * El valor = próximo estado.

 * Ejemplo:
 * Desde Q1 con 'x' vas a Q3, que es el estado “hexadecimal”. 
 */
    int AFD[ESTADOS][CLASES] = {
       // 0     1-7   8-9   xX    hex   otro
        { Q1,   Q2,   Q2,   QE,   QE,   QE }, // Q0
        { Q5,   Q5,   QE,   Q3,   QE,   QE }, // Q1
        { Q2,   Q2,   Q2,   QE,   QE,   QE }, // Q2
        { Q4,   Q4,   Q4,   QE,   Q4,   QE }, // Q3
        { Q4,   Q4,   Q4,   QE,   Q4,   QE }, // Q4
        { Q5,   Q5,   QE,   QE,   QE,   QE }, // Q5
        { QE,   QE,   QE,   QE,   QE,   QE }  // QE
    };

    // variables de control
    int c, estado = Q0; // c: carácter leído del archivo. estado: estado actual del AFD.
    char palabra[100]; // palabra: guarda la cadena actual.
    int i = 0; // i: indice dentro de la palabra

    // bucle de lectura
    while ((c = getc(f)) != EOF) { // Lee el archivo carácter por carácter.
        if (c == ',' || c == '\n') { // Cuando encuentra "," o "\n": El , marca el final de una palabra → se cierra la cadena con '\0'.
            palabra[i] = '\0';

            // Validacion de palabra completa
            // Chequear estado final válido
            // Los válidos son los mismos que los de doble círculo en el grafo (Q1, Q2, Q4, Q5).
            if (estado == Q1 || estado == Q2 || estado == Q4 || estado == Q5)
                printf("%s -> VALIDA\n", palabra);
            else
                printf("%s -> INVALIDA\n", palabra);
            // Reinicio para la próxima palabra
            estado = Q0;
            i = 0; // El autómata vuelve al estado inicial.
        } else { // Si no es coma ni salto de línea
            palabra[i++] = c;
            int clase = claseCaracter(c);
            estado = AFD[estado][clase];
        } // Guarda el carácter en la palabra actual.
        //Obtiene su clase (claseCaracter).

//Calcula el nuevo estado según la tabla AFD.
    }

    fclose(f); // Cierre
    return 0;
}