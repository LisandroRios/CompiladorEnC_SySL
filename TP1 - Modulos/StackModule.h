#ifndef STACKMODULE_H
#define STACKMODULE_H

typedef int StackItem;

/**
 * Deja la pila vacía, lista para usarse.
 * No importa en qué estado estaba antes.
 */
void Stack_init(void);

/**
 * Devuelve 1 (True) si la pila está vacía, 0 (False) si tiene algo.
 * No cambia nada en la pila.
 * Hay que haberla inicializado antes con Stack_init().
 */
int Stack_is_empty(void);

/**
 * Devuelve True(1) si la pila está llena, False(0) si todavía se puede agregar.
 * Solo tiene sentido en la versión estática.
 * No modifica la pila.
 */
int Stack_is_full(void);

/**
 * Agrega un nuevo elemento arriba de todo.
 * La pila no puede estar llena.
 */
void Stack_push(StackItem item);

/**
 * Saca el elemento que está arriba de todo y lo devuelve.
 * La pila no puede estar vacía.
 */
StackItem Stack_pop(void);

#endif
