CC = gcc
CFLAGS = -Wall -Wextra -Wno-sign-compare -Wno-unused-function -Wno-unneeded-internal-declaration -g


SRC_DIR = src
LEXER = $(SRC_DIR)/lexer.l
PARSER = $(SRC_DIR)/parser.y
SYMTAB = $(SRC_DIR)/symtab.c
MAIN = $(SRC_DIR)/main.c


LEX_C = $(SRC_DIR)/lex.yy.c
PARSER_C = $(SRC_DIR)/parser.tab.c
PARSER_H = $(SRC_DIR)/parser.tab.h

EXEC = analizador

all: $(EXEC)

$(EXEC): $(PARSER_C) $(LEX_C) $(SYMTAB) $(MAIN)
	$(CC) $(CFLAGS) -o $(EXEC) $(PARSER_C) $(LEX_C) $(SYMTAB) $(MAIN)

#Esta regla genera parser.tab.c y parser.tab.h solo una vez
$(PARSER_C) $(PARSER_H): $(PARSER)
	bison -d -o $(PARSER_C) $(PARSER)

#Esta regla genera lex.yy.c a partir del lexer
$(LEX_C): $(LEXER) $(PARSER_H)
	flex -o $(LEX_C) $(LEXER)

clean:
	rm -f $(LEX_C) $(PARSER_C) $(PARSER_H) $(EXEC)

run:
	@[ -n "$(FILE)" ] && ./$(EXEC) $(FILE) || echo "Uso: make run FILE=tests/ok_semantico.c"