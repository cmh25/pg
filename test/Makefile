CC ?= cc
CFLAGS ?= -g

all: behavior
	./test.sh slr
	../pg 001 slr strict >/dev/null
	./test.sh slr eunitr
	./test.sh lr1
	./test.sh lalr
	./test.sh lr0
	./test.sh ll1
	./behavior

behavior: behavior.c
	$(CC) $(CFLAGS) -std=c11 -o $@ $<

testv: behavior
	./valgrind.sh slr
	./valgrind.sh slr eunitr
	./valgrind.sh lr1
	./valgrind.sh lalr
	./valgrind.sh lr0
	./valgrind.sh ll1
	valgrind --error-exitcode=99 --leak-check=full \
	  --errors-for-leak-kinds=definite,indirect,possible ./behavior

clean:
	rm -f behavior
