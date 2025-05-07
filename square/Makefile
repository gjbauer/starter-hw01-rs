
CFLAGS := -no-pie -g

all:
	(make square || true)

square: square-main.o square.o
	clang $(CFLAGS) -o square square-main.o square.o
	chmod +x square

square-main.o: square-main.s
	clang $(CFLAGS) -c -o square-main.o square-main.s

square.o: square.c
	clang $(CFLAGS) -c -o square.o square.c

clean:
	rm -f *.o square ../screenfetch.txt

.PHONY: all clean
