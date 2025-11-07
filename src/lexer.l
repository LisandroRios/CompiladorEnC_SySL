%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"

#ifndef _MSC_VER
char* strdup(const char*);
#endif

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
static unsigned col = 1;
int tokcol;
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

{REAL1}            { yylval.fval = atof(yytext); return FLOAT_CONST; }
{REAL2}            { yylval.fval = atof(yytext); return FLOAT_CONST; }
{REAL3}            { yylval.fval = atof(yytext); return FLOAT_CONST; }

{HEXINT}           { yylval.ival = (int)strtol(yytext, NULL, 0); return INT_CONST; }
{OCTINT}           { yylval.ival = (int)strtol(yytext, NULL, 0); return INT_CONST; }
0                  { yylval.ival = 0; return INT_CONST; }
{DECINT}           { yylval.ival = (int)strtol(yytext, NULL, 10); return INT_CONST; }

{CHARLIT}          { yylval.ival = yytext[1]; return CHAR_CONST; }

{STRLIT}           { yylval.sval = strdup(yytext); return STRING_LITERAL; }

int|float|double|char|void|short|long|signed|unsigned|bool   { yylval.sval = strdup(yytext); return TYPE; }

if        { return IF; }
else      { return ELSE; }
while     { return WHILE; }
for       { return FOR; }
do        { return DO; }
switch    { return SWITCH; }
case      { return CASE; }
default   { return DEFAULT; }
break     { return BREAK; }
continue  { return CONTINUE; }
goto      { return GOTO; }


return    { return RETURN; }
sizeof|typedef|struct|union|enum|const|volatile|static|extern|register|auto|inline { yylval.sval = strdup(yytext); return IDENT; }

{ID}      { yylval.sval = strdup(yytext); return IDENT; }

"&&"      { return ANDAND; }
"||"      { return OROR; }
"=="      { return EQEQ; }
"!="      { return NEQ; }
"<="      { return LE; }
">="      { return GE; }

{OP_SGL}  { return yytext[0]; }

.         { LEXERR("Simbolo no reconocido"); return yytext[0]; }

%%
