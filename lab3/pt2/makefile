run: main.o checkPrimeNumber.o mod.o
	gcc -o run main.o checkPrimeNumber.o mod.o
main.o: main.s
	gcc -g -c main.s
checkPrimeNumber.o: checkPrimeNumber.c
	gcc -g -c checkPrimeNumber.c
mod.o: mod.s
	gcc -g -c mod.s
clean:
	rm *.o run
