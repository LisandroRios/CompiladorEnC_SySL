#include <stdio.h>
#include <stdlib.h>
#include "symtab.h"

extern int yyparse(void);
extern FILE* yyin;
extern int SEM_ERRORS;

int main(int argc, char** argv) {
    if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo_fuente.c>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("No se pudo abrir el archivo");
        return 2;
    }

    symtab_init();
    printf("Analizando archivo: %s\n", argv[1]);



    int res = yyparse();
    fclose(yyin);

    if (res == 0 && SEM_ERRORS == 0) {
        printf(" Análisis completo sin errores.\n");
        symtab_print();
        symtab_free();
        return 0;
    } else {
        printf(" Se detectaron errores.\n");
        symtab_print();
        symtab_free();
        // Devolvé 1 si hubo error sintáctico, 2 si solo semántico, 3 si ambos (opcional)
        if (res != 0 && SEM_ERRORS > 0) return 3;
        if (res != 0) return 1;
        return 2;
    }
}