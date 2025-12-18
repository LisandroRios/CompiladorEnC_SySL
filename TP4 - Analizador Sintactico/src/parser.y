%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Variables exportadas por el lexer */
extern int yylineno;
extern int tokcol;
int yylex(void);
void yyerror(const char *s);

/* Corta en el primer error */
static void fail(const char* msg){
  fprintf(stderr, "Error de sintaxis en linea %d, columna %d: %s\n", yylineno, tokcol, msg);
  exit(1);
}
%}

/* Tipos de valores semánticos */
%union {
  int    ival;
  double fval;
  char*  sval;
}

// ---------------------------------------------------
// TOKENS
// ---------------------------------------------------

%token <sval> TYPE
%token <sval> IDENT
%token <ival> INT_CONST
%token <fval> FLOAT_CONST
%token <ival> CHAR_CONST
%token <sval> STRING_LITERAL

%token IF ELSE WHILE FOR DO RETURN
%token SWITCH CASE DEFAULT BREAK CONTINUE GOTO
%token ANDAND OROR EQEQ NEQ LE GE

%left OROR
%left ANDAND
%left EQEQ NEQ
%left '<' '>' LE GE
%left '+' '-'
%left '*' '/'
%right '!' UMINUS

%start program

%%

// ---------------------------------------------------
// REGLAS DE GRAMATICA
// ---------------------------------------------------

program
  : stmt_list
  ;

stmt_list
  : /* vacío */
  | stmt_list stmt
  ;

stmt
  : declaration ';'
  | expr ';'
  | compound_stmt
  | IF '(' expr ')' stmt
  | IF '(' expr ')' stmt ELSE stmt
  | WHILE '(' expr ')' stmt
  | FOR '(' opt_expr ';' opt_expr ';' opt_expr ')' stmt
  | RETURN opt_expr ';'
  | function
  ;

compound_stmt
  : '{' stmt_list '}'
  ;

opt_expr
  : /* vacío */
  | expr
  ;

// ---------------------------------------------------
// FUNCIONES
// ---------------------------------------------------

function
  : TYPE IDENT '(' param_list_opt ')' compound_stmt
  ;

param_list_opt
  : /* vacío */
  | param_list
  ;

param_list
  : param_decl
  | param_list ',' param_decl
  ;

param_decl
  : TYPE IDENT
  ;

// ---------------------------------------------------
// DECLARACIONES
// ---------------------------------------------------

declaration
  : TYPE declarator_list
  ;

declarator_list
  : declarator
  | declarator_list ',' declarator
  ;

declarator
  : IDENT
  | IDENT '=' expr
  ;

// ---------------------------------------------------
// EXPRESIONES
// ---------------------------------------------------

expr
  : IDENT
  | INT_CONST
  | FLOAT_CONST
  | CHAR_CONST
  | STRING_LITERAL
  | '(' expr ')'
  | expr '+' expr
  | expr '-' expr
  | expr '*' expr
  | expr '/' expr
  | expr '>' expr
  | expr '<' expr
  | expr GE expr
  | expr LE expr
  | expr EQEQ expr
  | expr NEQ expr
  | '!' expr            %prec UMINUS
  | expr ANDAND expr
  | expr OROR expr
  | '-' expr            %prec UMINUS
  | IDENT '=' expr
  | IDENT '(' arg_list_opt ')'   /* llamada a función */
  ;
  arg_list_opt
  : /* vacío */
  | arg_list
  ;

arg_list
  : expr
  | arg_list ',' expr
  ;

  ;

%%

void yyerror(const char *s) {
  fail(s && *s ? s : "entrada invalida");
}
