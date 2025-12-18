# TP5 – Analizador Léxico, Sintáctico y Semántico

Este trabajo práctico implementa un **analizador léxico, sintáctico y semántico simplificado del lenguaje C**, desarrollado en C utilizando **Flex** para el análisis léxico y **Bison** para el análisis sintáctico y semántico.

Esta versión final (**TP5**) integra los tres análisis, validando declaraciones, asignaciones, llamadas a funciones y tipos de datos mediante una **tabla de símbolos**.

## Estructura del Proyecto (incluye archivos generados)

- `src/`: Contiene los archivos fuente del analizador.
  - `lexer.l`: Definición de las reglas léxicas para **Flex**.
  - `parser.y`: Definición de la gramática y reglas semánticas para **Bison**.
  - `symtab.c`: Implementación de la **tabla de símbolos**.
  - `symtab.h`: Definición de estructuras y funciones asociadas a la tabla de símbolos.
  - `main.c`: Punto de entrada del programa; invoca al analizador léxico y sintáctico.
  - `lex.yy.c`: Archivo C generado automáticamente por **Flex** a partir de `lexer.l`
  - `parser.tab.c`: Archivo C generado automáticamente por **Bison** a partir de `parser.y`
  - `parser.tab.h`: Header generado automáticamente por **Bison**
- `tests/`: Directorio con archivos de prueba.
  - `ok_semantico.c`: Caso de prueba con análisis semántico correcto.
  - `error_redef.c`: Error por **redefinición de identificadores**.
  - `error_llamada_args.c`: Error por **llamada a función con cantidad de argumentos incorrecta**.
  - `error_tipo_asignacion.c`: Error por **incompatibilidad de tipos en asignación**.
- `Makefile`: Script para automatizar la compilación, limpieza y ejecución de tests.
- `analizador`: Ejecutable resultante tras la compilación.
- `README.md`: Este archivo.

> **Nota:** los archivos `lex.yy.c`, `parser.tab.c`, `parser.tab.h` y el ejecutable `analizador` **se generan** al correr `make`. No están subidos al repositorio, solo se muestra qué son para mayor comprensión luego de compilar.

## Funcionalidades Implementadas

### Análisis Léxico

- Reconocimiento de:
  - **Palabras reservadas:** `int`, `float`, `char`, `void`
  - **Identificadores**
  - **Constantes numéricas**
  - **Operadores aritméticos y de asignación**
  - **Símbolos de puntuación**

### Análisis Sintáctico

- **Declaraciones de variables** y funciones
- **Definiciones de funciones con cuerpo**
- **Expresiones aritméticas** (`+`, `-`, `*`, `/`)
- **Asignaciones y llamadas a funciones**
- **Bloques de sentencias y retorno de funciones**

### Análisis Semántico

Validaciones implementadas mediante la **tabla de símbolos (`symtab`)**:

1. Doble declaración de variables o funciones.
2. Uso de variables no declaradas.
3. Incompatibilidad de tipos en asignaciones.
4. Validación de cantidad de parámetros en llamadas a funciones.

En caso de error, el programa muestra el **tipo de error**, el **identificador involucrado** y la **línea** donde ocurrió. Si se detecta un error, la ejecución termina mostrando el mensaje correspondiente (consigna TP: finalizar al detectar error).

## Instrucciones de Compilación

### Requisitos

- **Flex**
- **Bison**
- **GCC**

### Compilar el proyecto

Desde la raíz del proyecto, ejecutar:

```bash
make
```

Qué hace `make` (resumen):

- Ejecuta `bison -d -o src/parser.tab.c src/parser.y` → genera `src/parser.tab.c` y `src/parser.tab.h`
- Ejecuta `flex -o src/lex.yy.c src/lexer.l` → genera `src/lex.yy.c`
- Compila todos los `.c` y enlaza en el ejecutable `analizador`

Archivos generados al compilar:

- `src/parser.tab.c`, `src/parser.tab.h`, `src/lex.yy.c`, `analizador` (ejecutable)

### Limpiar archivos generados

```bash
make clean
```

La regla `clean` elimina: `src/lex.yy.c`, `src/parser.tab.c`, `src/parser.tab.h` y `analizador`.

## Ejecución

El programa recibe como parámetro un archivo `.c` para analizar:

```bash
./analizador tests/ok_semantico.c
```

También puede ejecutarse con el objetivo `run` del Makefile (usa la variable `FILE`):

```bash
make run FILE=tests/ok_semantico.c
```

Si no se especifica `FILE` con `make run`, el Makefile imprime la forma de uso.

## Casos de Prueba

| Archivo                     | Descripción                                              | Resultado Esperado                                     |
| --------------------------- | -------------------------------------------------------- | ------------------------------------------------------ |
| **ok_semantico.c**          | Código válido con declaraciones, suma y retorno correcto | “Análisis completo sin errores.”                       |
| **error_redef.c**           | Doble declaración de una variable                        | Error: variable ‘x’ ya declarada                       |
| **error_llamada_args.c**    | Llamada a función con cantidad incorrecta de argumentos  | Error: función ‘f’ esperaba 2 parámetros, se pasaron 1 |
| **error_tipo_asignacion.c** | Asignación de un string a una variable entera            | Error: tipos incompatibles en asignación               |

Cada caso se puede ejecutar con:

```bash
make run FILE=tests/<nombre_del_archivo>.c
```

## Ejemplo de Ejecución

### Entrada:

```c
int sumar(int a, int b) {
    int r = a + b;
    return r;
}

int main() {
    int x = 3;
    int y = 4;
    int z;
    z = sumar(x, y);
    return 0;
}
```

### Salida:

```
Analizando archivo: tests/ok_semantico.c
 Análisis completo sin errores.

Tabla de símbolos:
  sumar  (0)  params:2
  z      (0)  params:0
  y      (0)  params:0
  x      (0)  params:0
  main   (0)  params:0
```

## Detalles Técnicos

- **Archivo principal:** `main.c` — Controla la ejecución del parser y el manejo de archivos.
- **Integración Flex–Bison:** el `parser.y` invoca funciones definidas en `symtab.c` para manejar las validaciones semánticas.
- **Tabla de símbolos:** implementada como lista enlazada con funciones para agregar, buscar, imprimir y liberar símbolos.
- **Manejo de errores:** al detectar un error léxico, sintáctico o semántico el programa imprime un mensaje con detalles y finaliza con código distinto de 0.
