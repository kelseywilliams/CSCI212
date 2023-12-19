lab5: main.o mod.o gen_key.o print_key.o
	gcc -o lab5 main.o mod.o gen_key.o print_key.o
main.o: main.s
	gcc -g -c main.s

mod.o: mod.s
	gcc -g -c mod.s

gen_key.o: gen_key.s
	gcc -g -c gen_key.s
print_key.o: print_key.c
	gcc -g -c print_key.c
clean:
	rm *.o lab5	
