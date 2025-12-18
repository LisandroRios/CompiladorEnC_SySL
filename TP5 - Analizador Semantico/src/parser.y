%{
#include <stdio.h>
#include <stdlib.h>
#include "symtab.h"

int yylex(void);
void yyerror(const char *s);
extern int yylineno;

int SEM_ERRORS = 0;
#define SEMERR(...) do { fprintf(stderr, __VA_ARGS__); fputc('\n', stderr); SEM_ERRORS++; } while(0)

/* ===========================================================
   FUNCIONES AUXILIARES
   =========================================================== */
static int can_assign(Type dst, Type src) {
    if (dst == TYPE_ERROR || src == TYPE_ERROR) return 0;
    return dst == src;
}


static Type current_fn_type = TYPE_VOID;

static Type tmp_param_types[MAX_PARAMS];
static int  tmp_param_count = 0;

static Type tmp_arg_types[MAX_PARAMS];
static int  tmp_arg_count = 0;
%}

/* Exporta tipos para el lexer y otros módulos */
%code requires {
    #include "symtab.h"
}

/* ---------------- TIPOS DEL VALOR SEMÁNTICO ---------------- */
%union {
    int ival;
    char* sval;
    Type type;
    int count;
}

/* ---------------- TOKENS ---------------- */
%token <sval> IDENT
%token <ival> NUMBER
%token <sval> STRING     /* <-- NUEVO TOKEN para literales de cadena */
%token INT FLOAT CHAR VOID
%token IF ELSE WHILE FOR RETURN
%token EQ NEQ GE LE AND OR
%token ASSIGN SEMI COMMA
%token LPAREN RPAREN LBRACE RBRACE
%token PLUS MINUS TIMES DIV

/* ---------------- TIPOS DE NO TERMINALES ---------------- */
%type <type> type expr term factor
%type <count> param_list param_list_opt arg_list arg_list_opt

%start program

%%

/* ===========================================================
   PROGRAMA PRINCIPAL
   =========================================================== */
program:
    decl_list
;

/* ===========================================================
   LISTA DE DECLARACIONES Y FUNCIONES
   =========================================================== */
decl_list:
      /* vacío */
    | decl_list func_decl
    | decl_list func_def
    | decl_list decl
    | decl_list func_call
;

/* ===========================================================
   DECLARACIONES DE VARIABLES Y ASIGNACIONES
   =========================================================== */
decl:
      type IDENT SEMI {
        if ($1 == TYPE_VOID) {
            SEMERR("Error: variable '%s' no puede ser de tipo void (línea %d)\n", $2, yylineno);
        } else if (symtab_add($2, $1, 0, 0) != 0) {
            SEMERR("Error: variable '%s' ya declarada (línea %d)\n", $2, yylineno);
        }
      }
    | type IDENT ASSIGN expr SEMI {
        if ($1 == TYPE_VOID) {
            SEMERR("Error: variable '%s' no puede ser de tipo void (línea %d)\n", $2, yylineno);
        } else if (!can_assign($1, $4)) {
            SEMERR("Error: inicialización incompatible de '%s' (línea %d)\n", $2, yylineno);
        } else if (symtab_add($2, $1, 0, 0) != 0) {
            SEMERR("Error: variable '%s' ya declarada (línea %d)\n", $2, yylineno);
        }
      }
    | IDENT ASSIGN expr SEMI {
        Symbol* s = symtab_lookup($1);
        if (!s)
            SEMERR("Error: variable '%s' no declarada (línea %d)\n", $1, yylineno);
        else if (!can_assign(s->type, $3))
            SEMERR("Error: tipos incompatibles en asignación a '%s' (línea %d)\n", $1, yylineno);
      }
;

/* ===========================================================
   DECLARACIÓN DE FUNCIÓN (solo prototipo)
   =========================================================== */
func_decl:
    type IDENT LPAREN param_list_opt RPAREN SEMI {
        if (symtab_add($2, $1, 1, $4) != 0) {
            SEMERR("Error: función '%s' ya declarada (línea %d)\n", $2, yylineno);
        } else {
            Symbol* f = symtab_lookup($2);
            if (f) {
                int n = ($4 < MAX_PARAMS) ? $4 : MAX_PARAMS;
                for (int i = 0; i < n; ++i) f->params[i] = tmp_param_types[i];
                f->paramCount = n;
            }
        }
    }
;

/* ===========================================================
   DEFINICIÓN DE FUNCIÓN CON CUERPO
   =========================================================== */
func_def:
    type IDENT LPAREN param_list_opt RPAREN
    {
        current_fn_type = $1;
    }
    compound_stmt
    {
        if (symtab_add($2, $1, 1, $4) != 0) {
            SEMERR("Error: función '%s' ya declarada (línea %d)\n", $2, yylineno);
        } else {
            Symbol* f = symtab_lookup($2);
            if (f) {
                int n = ($4 < MAX_PARAMS) ? $4 : MAX_PARAMS;
                for (int i = 0; i < n; ++i) f->params[i] = tmp_param_types[i];
                f->paramCount = n;
            }
        }
        current_fn_type = TYPE_VOID; 
    }
;

/* ===========================================================
   BLOQUES Y SENTENCIAS DENTRO DE FUNCIONES
   =========================================================== */
compound_stmt:
    LBRACE stmt_list RBRACE
;

stmt_list:
      /* vacío */
    | stmt_list stmt
;

stmt:
      decl
    | expr SEMI
    | RETURN expr SEMI {
          if (!can_assign(current_fn_type, $2)) {
              SEMERR("Error: tipo de retorno incompatible (línea %d)\n", yylineno);
          }
      }
    | RETURN SEMI {
          if (current_fn_type != TYPE_VOID) {
              SEMERR("Error: 'return;' solo permitido en funciones void (línea %d)\n", yylineno);
          }
      }
;

/* ===========================================================
   LLAMADA A FUNCIÓN
   =========================================================== */
func_call:
    IDENT LPAREN { tmp_arg_count = 0; } arg_list_opt RPAREN SEMI {
        Symbol* f = symtab_lookup($1);
        if (!f)
            SEMERR("Error: función '%s' no declarada (línea %d)\n", $1, yylineno);
        else if (!f->isFunction)
            SEMERR("Error: '%s' no es una función (línea %d)\n", $1, yylineno);
        else {
            if (f->paramCount != $4) {  /* ✅ $4 en lugar de $3 */
                SEMERR("Error: función '%s' esperaba %d parámetros, se pasaron %d (línea %d)\n",
                        $1, f->paramCount, $4, yylineno);
            } else {
                for (int i = 0; i < f->paramCount; ++i) {
                    if (!can_assign(f->params[i], tmp_arg_types[i])) {
                        SEMERR("Error: arg %d de '%s' incompatible (esperado %d, recibido %d) (línea %d)\n",
                                i+1, $1, f->params[i], tmp_arg_types[i], yylineno);
                        break;
                    }
                }
            }
        }
    }
;


/* ===========================================================
   PARÁMETROS Y ARGUMENTOS
   =========================================================== */
param_list_opt:
    { tmp_param_count = 0; $$ = 0; }
    | VOID       { tmp_param_count = 0; $$ = 0; }
    | param_list { $$ = $1; }
;

param_list:
      type IDENT {
          if ($1 == TYPE_VOID) {
              SEMERR("Error: parámetro '%s' no puede ser 'void' (línea %d)\n", $2, yylineno);
          }
          if (symtab_add($2, $1, 0, 0) != 0) {
              SEMERR("Error: parámetro duplicado '%s' (línea %d)\n", $2, yylineno);
          }
          if (tmp_param_count < MAX_PARAMS) tmp_param_types[tmp_param_count++] = $1;
          $$ = 1;
      }
    | param_list COMMA type IDENT {
          if ($3 == TYPE_VOID) {
              SEMERR("Error: parámetro '%s' no puede ser 'void' (línea %d)\n", $4, yylineno);
          }
          if (symtab_add($4, $3, 0, 0) != 0) {
              SEMERR("Error: parámetro duplicado '%s' (línea %d)\n", $4, yylineno);
          }
          if (tmp_param_count < MAX_PARAMS) tmp_param_types[tmp_param_count++] = $3;
          $$ = $1 + 1;
      }
;

arg_list_opt:
      { tmp_arg_count = 0; $$ = 0; }  /* Reinicia SIEMPRE antes de cada llamada */
    | arg_list { $$ = $1; }
;

arg_list:
      expr {
          if (tmp_arg_count < MAX_PARAMS)
              tmp_arg_types[tmp_arg_count++] = $1;
          $$ = 1;
      }
    | arg_list COMMA expr {
          if (tmp_arg_count < MAX_PARAMS)
              tmp_arg_types[tmp_arg_count++] = $3;
          $$ = $1 + 1;
      }
;

/* ===========================================================
   TIPOS DE DATOS
   =========================================================== */
type:
    INT   { $$ = TYPE_INT; }
  | FLOAT { $$ = TYPE_FLOAT; }
  | CHAR  { $$ = TYPE_CHAR; }
  | VOID  { $$ = TYPE_VOID; }
;

/* ===========================================================
   EXPRESIONES Y OPERACIONES ARITMÉTICAS
   =========================================================== */
expr:
    expr PLUS term { $$ = ($1 == TYPE_FLOAT || $3 == TYPE_FLOAT) ? TYPE_FLOAT : TYPE_INT; }
  | expr MINUS term { $$ = ($1 == TYPE_FLOAT || $3 == TYPE_FLOAT) ? TYPE_FLOAT : TYPE_INT; }
  | term { $$ = $1; }
;

term:
    term TIMES factor { $$ = ($1 == TYPE_FLOAT || $3 == TYPE_FLOAT) ? TYPE_FLOAT : TYPE_INT; }
  | term DIV factor { $$ = TYPE_FLOAT; }
  | factor { $$ = $1; }
;


factor:
      NUMBER { $$ = TYPE_INT; }
    | IDENT {
          Symbol* s = symtab_lookup($1);
          if (!s) {
              SEMERR("Error: variable '%s' no declarada (línea %d)\n", $1, yylineno);
              $$ = TYPE_ERROR;
          } else $$ = s->type;
      }
    | LPAREN expr RPAREN { $$ = $2; }
    | STRING { $$ = TYPE_STRING; }
    | IDENT LPAREN { tmp_arg_count = 0; } arg_list_opt RPAREN {
        Symbol* s = symtab_lookup($1);
        if (!s) {
            SEMERR("Error: función '%s' no declarada (línea %d)\n", $1, yylineno);
            $$ = TYPE_ERROR;
        } else if (!s->isFunction) {
            SEMERR("Error: '%s' no es una función (línea %d)\n", $1, yylineno);
            $$ = TYPE_ERROR;
        } else if ($4 != s->paramCount) {   /* ✅ corregido: era $3 */
            SEMERR("Error semántico: función '%s' llamada con %d argumentos (se esperaban %d) (línea %d)\n",
                    $1, $4, s->paramCount, yylineno);
            $$ = TYPE_ERROR;
        } else {
            for (int i = 0; i < s->paramCount; i++) {
                if (!can_assign(s->params[i], tmp_arg_types[i])) {
                    SEMERR("Error semántico: argumento %d de '%s' incompatible (esperado tipo %d, recibido tipo %d) (línea %d)\n",
                            i + 1, s->name, s->params[i], tmp_arg_types[i], yylineno);
                    $$ = TYPE_ERROR;
                    break;
                }
            }
            $$ = s->type;
        }
    }
;



%%

/* ===========================================================
   MANEJO DE ERRORES
   =========================================================== */
void yyerror(const char *s) {
    SEMERR("Error de sintaxis en línea %d: %s\n", yylineno, s);
}
