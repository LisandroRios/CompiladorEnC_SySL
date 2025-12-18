# Compilador y flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99

# Archivos fuente
TEST_SRC = StackModuleTest.c
STATIC_SRC = StackModuleContiguousStatic.c
DYNAMIC_SRC = StackModuleLinkedDynamic.c

# Ejecutables
STATIC_BIN = test_static
DYNAMIC_BIN = test_dynamic

# Regla por defecto
all: $(STATIC_BIN) $(DYNAMIC_BIN)

# Compilar implementación estática
$(STATIC_BIN): $(TEST_SRC) $(STATIC_SRC)
	$(CC) $(CFLAGS) -o $@ $^

# Compilar implementación dinámica
$(DYNAMIC_BIN): $(TEST_SRC) $(DYNAMIC_SRC)
	$(CC) $(CFLAGS) -o $@ $^

# Ejecutar test estático
run_static: $(STATIC_BIN)
	./$(STATIC_BIN)

# Ejecutar test dinámico
run_dynamic: $(DYNAMIC_BIN)
	./$(DYNAMIC_BIN)

# Limpiar binarios
clean:
	rm -f $(STATIC_BIN) $(DYNAMIC_BIN)
