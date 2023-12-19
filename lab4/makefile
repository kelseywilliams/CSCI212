run: main.o print_array.o random.o mod.o split_deck.o check_stable.o left_shift.o move.o
	gcc -o run main.o print_array.o random.o mod.o split_deck.o check_stable.o move.o left_shift.o
main.o: main.s
	gcc -c -g main.s
print_array.o: print_array.s
	gcc -c -g print_array.s
random.o: random.s
	gcc -c -g random.s
mod.o: mod.s
	gcc -c -g mod.s
split_deck.o: split_deck.s
	gcc -c -g split_deck.s
check_stable.o: check_stable.s
	gcc -c -g check_stable.s
left_shift.o: left_shift.s
	gcc -c -g left_shift.s
move.o: move.s
	gcc -c -g move.s
clean:
	rm *.o run
