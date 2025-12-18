%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if defined(__unix__) || defined(__APPLE__)
  #include <unistd.h>
#else
  #include <io.h>
  #ifndef fileno
    #define fileno _fileno
  #endif
  #ifndef isatty
    #define isatty _isatty
  #endif
#endif

/* si después de todo esto no hay prototipo, lo declaramos a mano */
#ifndef HAVE_FILENO_PROTO
  extern int fileno(FILE *);
#endif

extern int yylineno;
static unsigned col = 1, tokcol = 1;
#define YY_USER_ACTION tokcol = col; col += yyleng;
int TOK_COUNT = 0;
#define EMIT(cat) do { TOK_COUNT++; printf("[L%u C%u] %-24s: %s\n", (unsigned)yylineno, tokcol, cat, yytext); } while(0)
int LEX_ERRORS = 0;
#define LEXERR(msg) do { fprintf(stderr, "[L%u C%u] ERROR LEXICO: %s -> \"%s\"\n", (unsigned)yylineno, tokcol, msg, yytext); LEX_ERRORS++; } while(0)
%}


%option noyywrap
%option yylineno
%option nounput
%option noinput
%x CMT

WS        [ \t\r\f\v]+
NL        \n
LINECOMM  \/\/[^\n]*

HEXINT    0[xX][0-9a-fA-F]+
OCTINT    0[0-7]+
DECINT    [1-9][0-9]*

REAL1     ([0-9]*\.[0-9]+)([eE][+-]?[0-9]+)?[fFlL]?
REAL2     ([0-9]+\.[0-9]*)([eE][+-]?[0-9]+)?[fFlL]?
REAL3     ([0-9]+)([eE][+-]?[0-9]+)[fFlL]?

CHARLIT   \'([^\'\\]|\\.)\'
STRLIT    \"([^\"\\]|\\.)*\"

ID        [a-zA-Z_][a-zA-Z0-9_]*
OP_MUL    (\+\+|--|->|<<=|>>=|==|!=|<=|>=|&&|\|\||<<|>>|\+=|-=|\*=|\/=|%=|&=|\|=|\^=)
OP_SGL    [+\-*/%&|^~!<>=?:.,;()\[\]{}#]

%%

{WS}               ;
{NL}               { col = 1; }
{LINECOMM}         ;

"/*"               { BEGIN(CMT); }
<CMT>[^*]+         ;
<CMT>"*"+[^*/]     ;
<CMT>"*"+"/"       { BEGIN(INITIAL); }

{REAL1}            { EMIT("Constante real"); }
{REAL2}            { EMIT("Constante real"); }
{REAL3}            { EMIT("Constante real"); }

{HEXINT}           { EMIT("Constante entera hexadecimal"); }
{OCTINT}           { EMIT("Constante entera octal"); }
0                  { EMIT("Constante entera octal"); }
{DECINT}           { EMIT("Constante entera decimal"); }

{CHARLIT}          { EMIT("Constante caracter"); }

{STRLIT}           { EMIT("Literal cadena"); }

int|float|double|char|void|short|long|signed|unsigned|bool   { EMIT("Reservada tipo de dato"); }

if        { EMIT("Reservada control de flujo"); }
else      { EMIT("Reservada control de flujo"); }
while     { EMIT("Reservada control de flujo"); }
for       { EMIT("Reservada control de flujo"); }
do        { EMIT("Reservada control de flujo"); }
switch    { EMIT("Reservada control de flujo"); }
case      { EMIT("Reservada control de flujo"); }
default   { EMIT("Reservada control de flujo"); }
break     { EMIT("Reservada control de flujo"); }
continue  { EMIT("Reservada control de flujo"); }
goto      { EMIT("Reservada control de flujo"); }

return|sizeof|typedef|struct|union|enum|const|volatile|static|extern|register|auto|inline { EMIT("Reservada otros"); }

{ID}               { EMIT("Identificador"); }
{OP_MUL}           { EMIT("Operador/puntuacion"); }
{OP_SGL}           { EMIT("Operador/puntuacion"); }

.                  { LEXERR("Simbolo no reconocido"); }

%%
