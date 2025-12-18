%{
#include "parser.tab.h"
#include "symtab.h"
#include <string.h>
%}

%option noyywrap yylineno

%%
"int"      { return INT; }
"float"    { return FLOAT; }
"char"     { return CHAR; }
"void"     { return VOID; }
"return"   { return RETURN; }
"if"       { return IF; } 
"else"     { return ELSE; } 
"while"    { return WHILE; } 
"for"      { return FOR; }
"\xEF\xBB\xBF"    ;
[0-9]+     { yylval.ival = atoi(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]* { yylval.sval = strdup(yytext); return IDENT; }
"="        { return ASSIGN; }
";"        { return SEMI; }
"("        { return LPAREN; }
")"        { return RPAREN; }
","        { return COMMA; }
"+"        { return PLUS; }
"-"        { return MINUS; }
"*"        { return TIMES; }
"/"        { return DIV; }
"{"        { return LBRACE; }
"}"        { return RBRACE; }
"=="       { return EQ; }
"!="       { return NEQ; }
">="       { return GE; }
"<="       { return LE; }
"&&"       { return AND; }
"||"       { return OR; }
[ \t\r\n]+ ;
.          { return yytext[0]; }
\"[^\"]*\"        { yylval.sval = strdup(yytext); return STRING; }

%%