# TP3: Analizador Léxico para un Subconjunto de C

Este proyecto implementa un **analizador léxico** para un subconjunto del lenguaje C, utilizando la herramienta **Flex**. El objetivo principal del Trabajo Práctico #3 es reconocer las categorías léxicas especificadas en la consigna, generar un reporte de los tokens encontrados y manejar los errores léxicos.

El analizador procesa un archivo fuente `.c` y muestra por consola cada token reconocido, indicando su categoría, lexema, línea y columna. En caso de detectar un error léxico, imprime un mensaje detallado y termina la ejecución.

## Estructura del Proyecto

El repositorio se organiza de la siguiente manera:

- `src/`: Contiene los archivos fuente del analizador.
  - `main.c`: Programa principal que invoca al analizador léxico.
  - `lexer.l`: Definición de las reglas léxicas para Flex.
- `lex.yy.c`: Archivo C generado automáticamente por Flex a partir de `lexer.l` (no editar manualmente).
- `Makefile`: Script para automatizar la compilación, limpieza y tests.
- `tests/`: Directorio con archivos de prueba.
  - `err_invalid_number.c`: Error en número octal inválido.
  - `err_lex_unrecognized_char.c`: Error por carácter no reconocido.
  - `err_unterminated_string.c`: Error por cadena sin cierre.
  - `valid_comments.c`: Comentarios válidos.
  - `valid_numbers.c`: Constantes numéricas válidas.
  - `valid_tokens.c`: Variedad de tokens válidos.
- `README.md`: Este archivo.

## Instalación y Compilación

Para compilar y ejecutar el proyecto, seguí estos pasos usando el `Makefile` proporcionado. El Makefile automatiza la generación del código con Flex, la compilación con GCC y la creación del ejecutable `lexer`.

### Pasos de Compilación (Notas del Makefile Integradas):

1. **Limpiar todo**: Ejecutá `make clean` para eliminar archivos temporales (como `lex.yy.c`, objetos `.o`), el ejecutable generado y cualquier salida que no queremos. Esto asegura un entorno limpio antes de recompilar.

2. **Crear el ejecutable**: Ejecutá `make` en la consola para generar el archivo `lex.yy.c` con Flex, compilar los archivos fuente y enlazar todo en el ejecutable `lexer.exe` (en Windows) o `lexer` (en Linux/Unix, sin extensión).

Una vez compilado, el ejecutable estará en el directorio actual.

### Ejecución de Tests

Para verificar el correcto funcionamiento del analizador léxico:

- **Tests individuales**: Ejecutá `./lexer tests/NombreDelTest.c` (reemplaza "NombreDelTest.c" por el archivo real, como `valid_tokens.c` o `err_invalid_number.c`). Asegúrate de incluir la extensión `.c`.

- **Ejecutar todos los tests**: Usá el comando proporcionado en el Makefile, `make test`.

Esto correrá automáticamente todos los archivos en el directorio `tests/` y reportará resultados (válidos o con errores).

Si no se proporciona un archivo el programa mostrará un mensaje de uso y saldrá.

### Salida Esperada

- **Tokens válidos**: Lista cada uno con categoría (ej: `KEYWORD: int`), lexema, línea y columna.
- **Errores léxicos**: Mensaje detallado (ej: "Simbolo no reconocido: '@' en línea 5, columna 10") y terminación inmediata.
- **Resumen**: Si no hay errores, indica "Archivo válido" y el total de tokens leídos.

## Categorías Léxicas Reconocidas

El analizador léxico identifica las siguientes categorías (basadas en la consigna del TP):

- **Constantes**:
  - Entera decimal (ej: `123`)
  - Entera octal (ej: `0123`)
  - Entera hexadecimal (ej: `0x1A`)
  - Real (ej: `3.14`)
  - Carácter (ej: `'a'`)
- **Literal cadena** (ej: `"hello"`)
- **Palabras reservadas**:
  - Tipos de dato (ej: `int`, `float`, `char`)
  - Estructuras de control (ej: `if`, `while`, `for`)
  - Otras (ej: `return`, `void`)
- **Identificadores** (ej: `miVariable`)
- **Caracteres de puntuación y operadores** (ej: `+`, `-`, `*`, `/`, `=`, `;`, `{`, `}`, `(`, `)`, etc.)
- **Comentarios** (unilínea `//` y multilínea `/* */`, ignorados en tokens)

## Manejo de Errores Léxicos

Al detectar un error, el analizador imprime un mensaje detallado:

- Tipo de error (ej: "Simbolo no reconocido", "Constante octal invalida", "Cadena sin cierre antes de fin de linea").
- Lexema problemático.
- Ubicación (línea y columna).
- La ejecución termina inmediatamente después del primer error.

Si el archivo es válido, muestra un resumen con la cantidad total de tokens.
