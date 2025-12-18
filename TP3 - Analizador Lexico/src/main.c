#include <stdio.h>
#include <stdlib.h>

extern int yylex(void);
extern FILE* yyin;
extern int LEX_ERRORS;
extern int TOK_COUNT;

int main(int argc, char** argv){
    if(argc<2){ fprintf(stderr,"Uso: %s <archivo.c>\n",argv[0]); return 2; }
    yyin=fopen(argv[1],"r");
    if(!yyin){ perror("No se pudo abrir el archivo de entrada"); return 2; }

    yylex();

    fclose(yyin);
    if(LEX_ERRORS>0){ fprintf(stderr,"\nAnalisis lexico: %d error(es) detectado(s).\n", LEX_ERRORS); return 1; }
    printf("\nAnalisis lexico OK. Tokens leidos: %d\n", TOK_COUNT);
    return 0;
}