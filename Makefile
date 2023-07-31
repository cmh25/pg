CC=gcc
#CFLAGS=-O3
CFLAGS=-g

all: pg

pg: main.c pg.c pg.h show.c show.h pg.o show.o
	$(CC) $(CFLAGS) -o pg main.c pg.o show.o

test: pg
	./pg test/g0 > test/g0.out
	./pg test/basic > test/basic.out
	./pg test/k > test/k.out
	diff test/g0.res test/g0.out
	diff test/basic.res test/basic.out
	diff test/k.res test/k.out

clean:
	rm -f pg *.o test/*.out

.PHONY: test
