run: main.o checkPrimeNumber.o mod.o
	gcc -o run main.o checkPrimeNumber.o mod.o
main.o: main.c
	gcc -g -c main.c
checkPrimeNumber.o: checkPrimeNumber.s
	gcc -g -c checkPrimeNumber.s
mod.o: mod.s
	gcc -g -c mod.s
clean:
	rm *.o run
