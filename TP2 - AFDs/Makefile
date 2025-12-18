# Compilador y flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99

# Nombre del ejecutable
TARGET = afd

# Archivos fuente
SRC = main.c
OBJ = $(SRC:.c=.o)

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CC) $(CFLAGS) -o $(TARGET) $(OBJ)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Ejecutar con el archivo de prueba
run: $(TARGET)
	./$(TARGET) constantes.txt


clean:
	rm -f $(OBJ) $(TARGET)