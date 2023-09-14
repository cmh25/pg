CC=gcc
CFLAGS=-g

all: pg

pg: main.c pg.c pg.h show.c show.h pg.o show.o
	$(CC) $(CFLAGS) -o pg main.c pg.o show.o

test: pg
	$(MAKE) -C test

testv: pg
	$(MAKE) -C test testv

ex: pg
	$(MAKE) -C ex

clean:
	$(MAKE) -C ex clean
	rm -f pg *.o

.PHONY: test testv ex
