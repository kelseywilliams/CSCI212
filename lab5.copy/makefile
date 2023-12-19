run: main.o generate_key.o rand_gen.o mod.o get_guess.o print_key.o
	gcc -o run main.o generate_key.o rand_gen.o mod.o get_guess.o print_key.o
main.o: main.s
	gcc -c -g main.s
generate_key.o: generate_key.s
	gcc -c -g generate_key.s
rand_gen.o: rand_gen.s
	gcc -c -g rand_gen.s
mod.o: mod.s
	gcc -c -g mod.s
get_guess.o: get_guess.s
	gcc -c -g get_guess.s
print_key.o: print_key.c
	gcc -c -g print_key.c
clean:
	rm *.o run
