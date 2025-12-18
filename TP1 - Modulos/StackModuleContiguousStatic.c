#include "StackModule.h"
#include <stdio.h>  // Para usar printf

#define TAM_STACK 100

// Arreglo que almacena los elementos
static StackItem stack[TAM_STACK];
// Puntero que indica la posición del próximo espacio libre
static StackItem *top = stack;

// Inicializa la pila (coloca el puntero al inicio del arreglo)
void Stack_init(void) {
    top = stack;
}

// Devuelve 1 si la pila está vacía
int Stack_is_empty(void) {
    return top == stack;
}

// Devuelve true si la pila está llena
int Stack_is_full(void) {
    return top == (stack + TAM_STACK);
}

// Agrega un elemento al tope de la pila
void Stack_push(StackItem item) {
    if (Stack_is_full()) {
        printf("Error: la pila esta llena\n");
        return; // No se pudo insertar, la pila está llena
    }

    *top = item;
    top++;
    return;
}

// Saca y devuelve el último elemento agregado
StackItem Stack_pop(void) {
    if (Stack_is_empty()){
        printf("Error: la pila esta vacia\n");
        return 0; 
    }

    top--;
    return *top;
}
