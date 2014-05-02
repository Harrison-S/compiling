parser: syntax.tab.c lex.yy.c 
	gcc syntax.tab.c -lfl -ly -o parser
lex.yy.c: lexical.l
	flex lexical.l
syntax.tab.c: syntax.y
	bison -d syntax.y

clean:
	rm syntax.tab.c syntax.tab.h lex.yy.c parser
