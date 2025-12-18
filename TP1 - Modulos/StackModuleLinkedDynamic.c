#include <stdlib.h>
#include "StackModule.h"

// Cada nodo guarda un dato y un puntero al nodo que está debajo
typedef struct Node {
    StackItem data;      
    struct Node *next;    
} Node;

// Este puntero siempre apunta al nodo que está en la cima de la pila
static Node *top = NULL;

// Deja la pila vacía. Si ya había elementos, los libera de la memoria.
void Stack_init(void) {
    while (top != NULL) {
        Node *temp = top;      
        top = top->next;       
        free(temp);            
    }
}

// Devuelve verdadero si no hay ningún nodo en la pila
int Stack_is_empty(void) {
    return top == NULL;
}

// Como usamos memoria dinámica, no hay un límite fijo.
// Solo devuelve falso siempre (salvo que no haya memoria disponible).
int Stack_is_full(void) {
    return 0;
}

// Agrega un nuevo nodo en la cima de la pila
void Stack_push(StackItem item) {
    // Pedimos memoria para un nuevo nodo
    Node *new_node = malloc(sizeof *new_node);  // Usamos sizeof *new_node

    // Guardamos el dato y conectamos el nuevo nodo con el anterior
    new_node->data = item;
    new_node->next = top;

    // Ahora este nuevo nodo pasa a ser la nueva cima
    top = new_node;
}

// Quita el nodo que está en la cima y devuelve su dato
StackItem Stack_pop(void) {
    Node *temp = top;          
    StackItem value = temp->data; 

    top = top->next;           
    free(temp);               

    return value; 
}
