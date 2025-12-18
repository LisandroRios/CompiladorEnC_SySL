# Grupo 09 - K2151

# Benchmark
Cambiar segun sea necesario (entre segs o ms)

| Implementación         | Tiempo total (s) | Tiempo promedio por ejecución (s) |
|------------------------|------------------|-----------------------------------|
| Contigua Estática      | 0.000015         | 0.000015                          |
| Enlazada Dinámica      | 0.000018         | 0.000018                          |


# Teoria
a. ¿Cuál es la mejor implementación? Justifique.
Va a depender del contexto en el que se encuentre. En este caso particular sería mejor la implementación estática, porque al conocer el tamanio de la memoria hace que las operaciones puedan ser ejecutadas mucho mas rapido y de forma eficiente. En cambio, si no se conociera el tamanio, deberiamos tener mayor flexibilidad para manejar esto, y sería mas util la implementación dinamica.


b. ¿Qué cambios haría para que no haya precondiciones? ¿Qué implicancia
tiene el cambio?
Se podrían modificar las funciones para manejar de forma interna esas precondiciones, como por ejemplo agregar un retorno booleano indicando si fue posible ejecutar la función. 
Aunque esto podria generar un codigo un poco mas grande y dificil de seguir.


c. ¿Qué cambios haría en el diseño para que el stack sea genérico, es decir
permita elementos de otros tipos que no sean int? ¿Qué implicancia tiene
el cambio?
El cambio sería de que el stack almacene punteros a cualquier tipo dentro de "void*", y con esto se podría aumentar la flexibilidad del módulo, pero siempre y cuando se tenga cuidad con la gestión de memoria.


d. Proponga un nuevo diseño para que el módulo pase a ser un tipo de dato,
es decir, permita a un programa utilizar más de un stack.
Para permitir multiples stacks, definimos la siguiente estructura:
typedef struct {
    StackItem items[STACK_CAPACITY];
    int top;
} Stack;

y funcionarian recibiendo un puntero a la estructura:
void stack_init(Stack *s);
void stack_push(Stack *s, StackItem item);

De esta manera, se pueden crear multiples stacks para poder operar con ellos de forma independiente y tambien poder reutilizarlos.
