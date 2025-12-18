#include <stdio.h>
#include <stdlib.h>

extern int yyparse(void);
extern FILE* yyin;

int main(int argc, char** argv){
    if(argc < 2){
        fprintf(stderr, "Uso: %s <archivo.c>\n", argv[0]);
        return 2;
    }
    yyin = fopen(argv[1], "r");
    if(!yyin){
        perror("No se pudo abrir el archivo");
        return 2;
    }

    int rc = yyparse();
    fclose(yyin);

    if(rc == 0){
        printf("Archivo valido (sintaxis OK).\n");
        return 0;
    }else{
        /* yyerror ya imprime mensaje y corta con exit(1), así que acá normalmente no se llega */
        return 1;
    }
}