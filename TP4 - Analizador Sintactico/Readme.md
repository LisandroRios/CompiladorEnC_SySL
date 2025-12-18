# TP4: Analizador Sintáctico para un Subconjunto de C

Este proyecto implementa un **analizador sintáctico** para un subconjunto del lenguaje C, integrando **Flex** (léxico) y **Bison** (sintaxis). El objetivo principal del TP es **validar la estructura gramatical** de programas C simplificados: declaraciones, expresiones, bloques, sentencias de control y funciones.  
El analizador procesa un archivo fuente `.c` y reporta si la **sintaxis es válida** o, en caso contrario, muestra un **error de sintaxis** indicando línea y columna.

## Estructura del Proyecto

- `src/`: Contiene los fuentes.
  - `main.c`: Programa principal que invoca al parser (`yyparse()`).
  - `lexer.l`: Reglas léxicas (Flex). Devuelve tokens al parser (identificadores, literales, operadores, palabras reservadas).
  - `parser.y`: Gramática (Bison). Define producciones y precedencias.
- `parser.tab.c` / `parser.tab.h`: Generados por Bison a partir de `parser.y` (no editar).
- `lex.yy.c`: Generado por Flex a partir de `lexer.l` (no editar).
- `Makefile`: Automatiza compilación, limpieza y tests.
- `tests/`: Casos de prueba sintácticos (válidos y con errores).
- `README.md`: Este archivo.

## Instalación y Compilación

Usar el `Makefile` para construir todo (Flex + Bison + GCC):

1. Limpiar:
   ```bash
   make clean
   ```
2. Compilar:
   ```bash
   make
   ```
   Esto genera el ejecutable `analizador` (Linux/Mac) o `analizador.exe` (MSYS/Windows).

## Ejecución y Tests

- Ejecutar sobre un archivo:
  ```bash
  ./analizador tests/ok_funcion.c
  ```
- Ejecutar todos los tests del directorio `tests/`:
  ```bash
  make test
  ```

Si no se proporciona un archivo, el programa muestra un mensaje de uso y finaliza.

## Salida Esperada

- **Código válido**:
  ```
  Archivo valido (sintaxis OK).
  ```
- **Código con error sintáctico**:  
  Mensaje indicando la ubicación y descripción, por ejemplo:
  ```
  Error de sintaxis en linea 8, columna 12: syntax error
  ```

## Alcance del Analizador Sintáctico (Gramática)

Se valida la sintaxis de un modelo simplificado de C:

- **Declaraciones de variables** con tipos primitivos (sin punteros, arreglos ni `struct`).
  - Ejemplos: `int a;`, `float x = 3.14;`, `int a = 1, b, c = 2;`
- **Expresiones** aritméticas y lógicas:
  - `+ - * /`, `> >= < <= == !=`, `! && ||`, paréntesis y unarios (`-x`, `!x`).
  - Asignación simple: `ident = expr`.
- **Sentencias**:
  - Expresión terminada en `;` (ej.: `x = 10;`)
  - `if (expr) stmt` y `if (expr) stmt else stmt`
  - `while (expr) stmt`
  - `for (opt_expr; opt_expr; opt_expr) stmt`
  - `return;` y `return expr;`
  - Bloques: `{ stmt_list }`
- **Funciones**:
  - Cabecera simple con parámetros tipados y cuerpo en bloque:
    ```c
    int sumar(int a, int b) { ... }
    ```
  - **Llamadas a función** como expresión:
    ```c
    z = sumar(x, y);
    ```

## Tokens y Léxico (Resumen)

El lexer (Flex) reconoce:

- **Constantes**: enteras (decimal, octal, hexadecimal), reales, carácter.
- **Literales**: de cadena.
- **Identificadores**.
- **Palabras reservadas**: tipos (`int`, `float`, `char`, `void`, …), control (`if`, `else`, `while`, `for`, `do`, `return`).
- **Operadores y signos**: `+ - * /`, `== != <= >= < >`, `&& || !`, `= , ; ( ) { }`.

El lexer entrega a Bison tokens con valores semánticos cuando corresponde (por ejemplo, números y cadenas).

## Casos de Prueba de Referencia

- `ok_funcion.c`: función válida con declaraciones, expresiones, if/else y return → Sintaxis OK.
- `ok_for_while.c`: bucles `for` y `while` correctos → Sintaxis OK.
- `error_sin_puntoycoma.c`: falta `;` → Error de sintaxis.
- `error_llave.c`: falta `}` → Error de sintaxis.
- `ok_llamadas.c`: llamadas a funciones dentro de expresiones → Sintaxis OK.

Ejecutar:

```bash
./analizador tests/ok_funcion.c
./analizador tests/error_llave.c
```

## Manejo de Errores Sintácticos

Ante el **primer error de sintaxis** el analizador:

- Reporta mensaje con **línea** (`yylineno`) y **columna** (`tokcol`) del token problemático.
- Finaliza la ejecución con código de error.

Ejemplo:

```
Error de sintaxis en linea 5, columna 9: syntax error
```
