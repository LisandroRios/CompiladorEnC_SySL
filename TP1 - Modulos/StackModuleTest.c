#include <assert.h>
#include <stdio.h>
#include <time.h>
#include "StackModule.h"

int main(void) {
    clock_t start, end;
    double cpu_time_used;

    printf("===== INICIO DE TESTS DEL MODULO STACK =====\n\n");

    // -----------------------------
    // Test 1: Inicialización (Stack_init)
    // -----------------------------
    printf("[Test 1] Inicializando la pila...\n");
    Stack_init();
    assert(Stack_is_empty() == 1);
    printf("Stack_init: la pila se inicializó correctamente (vacía)\n\n");

    start = clock();

    // -----------------------------
    // Test 2: Verificar is_empty
    // -----------------------------
    printf("[Test 2] Verificando Stack_is_empty()...\n");
    assert(Stack_is_empty() == 1);
    Stack_push(100);
    assert(Stack_is_empty() == 0);
    printf("Stack_is_empty: detecta correctamente pila vacía y no vacía\n\n");

    // -----------------------------
    // Test 3: Verificar push
    // -----------------------------
    printf("[Test 3] Probando Stack_push()...\n");
    Stack_init(); // volvemos a vaciar
    Stack_push(10);
    Stack_push(20);
    Stack_push(30);
    assert(Stack_is_empty() == 0);
    printf("Stack_push: se apilaron correctamente los elementos 10, 20, 30\n\n");

    // -----------------------------
    // Test 4: Verificar pop
    // -----------------------------
    printf("[Test 4] Probando Stack_pop()...\n");
    StackItem x = Stack_pop();
    assert(x == 30);
    x = Stack_pop();
    assert(x == 20);
    x = Stack_pop();
    assert(x == 10);
    assert(Stack_is_empty() == 1);
    printf("Stack_pop: se desapilaron correctamente los elementos en orden LIFO\n\n");

    end = clock();
    cpu_time_used = ((double)(end - start)) / CLOCKS_PER_SEC;

    // -----------------------------
    // Test final: Resumen
    // -----------------------------
    printf("===== TODOS LOS TESTS SE EJECUTARON CORRECTAMENTE =====\n");
    printf("Tiempo total de ejecución: %.6f segundos\n", cpu_time_used);

    return 0;
}
