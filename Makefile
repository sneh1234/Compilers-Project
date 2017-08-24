all:
	bison -d decaf.y
	flex decaf.l 
	g++ -std=c++11 decaf.tab.c  lex.yy.c -lfl
	
clean:
	rm -f test_output a.out lex.yy.c decaf.tab.* flex_output.txt
