CC      := gcc
CFLAGS  := -Wall -Wextra -std=c99
FLEX    := flex
BISON   := bison

SRC_DIR := src
TARGET  := analizador

all: $(TARGET)

parser.tab.c parser.tab.h: $(SRC_DIR)/parser.y
	$(BISON) -d -o parser.tab.c $<

lex.yy.c: $(SRC_DIR)/lexer.l parser.tab.h
	$(FLEX) -o $@ $<

$(TARGET): $(SRC_DIR)/main.c parser.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o $@ $^

test: $(TARGET)
	@for f in tests/*.c; do \
	  echo "==== $$f ===="; \
	  ./$(TARGET) "$$f" || true; \
	  echo; \
	done

clean:
	rm -f $(TARGET) parser.tab.c parser.tab.h lex.yy.c

.PHONY: all clean test
