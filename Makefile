CC=gcc
#CFLAGS=-O3
CFLAGS=-g

all: pg

pg: main.c pg.c pg.h show.c show.h pg.o show.o
	$(CC) $(CFLAGS) -o pg main.c pg.o show.o

test: pg
	$(MAKE) -C test

clean:
	rm -f pg *.o test/*.out

.PHONY: test
