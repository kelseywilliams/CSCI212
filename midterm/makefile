play_poker: main.o user_input.o shuffle_cards.o mod.o replace_card.o deal_cards.o print_cards.o print_poker.o sort.o swap.o
	gcc -o play_poker main.o user_input.o shuffle_cards.o mod.o replace_card.o deal_cards.o print_cards.o print_poker.o sort.o swap.o

main.o: main.s
	gcc -g -c main.s

user_input.o: user_input.s
	gcc -g -c user_input.s
	
shuffle_cards.o: shuffle_cards.s
	gcc -g -c shuffle_cards.s 
 
mod.o: mod.s
	gcc -g -c mod.s
	
deal_cards.o: deal_cards.s
	gcc -g -c deal_cards.s
	
print_poker.o: print_poker.s
	gcc -g -c print_poker.s

replace_card.o: replace_card.c
	gcc -g -c replace_card.c
	
print_cards.o: print_cards.s
	gcc -g -c print_cards.s
	
sort.o: sort.s
	gcc -g -c sort.s
	
swap.o: swap.s
	gcc -g -c swap.s

clean:
	rm *.o
