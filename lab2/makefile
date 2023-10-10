main: main.o Fibonacci.o gcd.o
	gcc -o main main.o Fibonacci.o gcd.o
main.o: main.s
	gcc -c -g main.s
Fibonacci.o: Fibonacci.s
	gcc -c -g Fibonacci.s
gcd.o: gcd.s
	gcc -c -g gcd.s
clean:
	rm *.o

