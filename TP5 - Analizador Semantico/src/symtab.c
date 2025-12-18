#include "symtab.h"

static Symbol* symtab_head = NULL;

void symtab_init(void) {
    symtab_head = NULL;
}

Symbol* symtab_lookup(const char* name) {
    for (Symbol* s = symtab_head; s; s = s->next)
        if (strcmp(s->name, name) == 0) return s;
    return NULL;
}

int symtab_add(const char* name, Type type, int isFunction, int paramCount) {
    if (symtab_lookup(name)) return -1;
    Symbol* s = malloc(sizeof(Symbol));
    s->name = strdup(name);
    s->type = type;
    s->isFunction = isFunction;
    s->paramCount = paramCount;
    s->next = symtab_head;
    symtab_head = s;
    return 0;
}

void symtab_print(void) {
    printf("\nTabla de símbolos:\n");
    for (Symbol* s = symtab_head; s; s = s->next)
        printf("  %s\t(%d)\tparams:%d\n", s->name, s->type, s->paramCount);
}

void symtab_free(void) {
    Symbol* s = symtab_head;
    while (s) {
        Symbol* next = s->next;
        free(s->name);
        free(s);
        s = next;
    }
    symtab_head = NULL;
}
