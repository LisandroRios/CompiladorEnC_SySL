# CC es una variable estándar de Make para el compilador de C.El ?= significa: “asignar este valor solo si no estaba definido antes”.
CC	?= gcc # Esto permite que el usuario reemplace el compilador desde la consola, por ejemplo: make CC=clang; usaría Clang en vez de GCC.


CFLAGS  ?= -Wall -Wextra -std=c99 # CFLAGS son los flags del compilador. -Wall → muestra todas las advertencias comunes. -Wextra → muestra advertencias adicionales.
# -std=c99 → asegura que el código se compile con el estándar C99.
# Esto es lo que pide la consigna: buena portabilidad y código limpio.

#  Define el ejecutable de Flex, el generador del analizador léxico.
FLEX    ?= flex 
# el ?= permite que, si alguien quiere usar otra versión (por ejemplo win_flex en Windows), pueda hacerlo al ejecutar: make FLEX=win_flex

# Archivos y carpetas
TARGET  := lexer
SRC := src
LEX := $(SRC)/lexer.l
MAIN := $(SRC)/main.c

# Regla principal
all: $(TARGET)

# Generar lex.yy.c usando Flex
lex.yy.c: $(LEX)
	$(FLEX) -o $@ $<

$(TARGET): $(MAIN) lex.yy.c
	$(CC) $(CFLAGS) -o $@ $(MAIN) lex.yy.c

test: $(TARGET)
	@for f in tests/*.c; do \
		echo "==== $$f ===="; \
		./$(TARGET) "$$f" || true; \
		echo; \
	done

clean:
	rm -f $(TARGET) lex.yy.c

.PHONY: all clean test
