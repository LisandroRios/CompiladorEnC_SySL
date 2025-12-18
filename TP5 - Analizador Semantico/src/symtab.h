#ifndef SYMTAB_H
#define SYMTAB_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_CHAR,
    TYPE_VOID,
    TYPE_ERROR,
    TYPE_STRING
} Type;

#define MAX_PARAMS 16

typedef struct Symbol {
    char* name;
    Type type;
    int isFunction;
    int paramCount;
    Type params[MAX_PARAMS];
    struct Symbol* next;
} Symbol;

void symtab_init(void);
Symbol* symtab_lookup(const char* name);
int symtab_add(const char* name, Type type, int isFunction, int paramCount);
void symtab_print(void);
void symtab_free(void);

#endif