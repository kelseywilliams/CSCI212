play_poker: main.o user_input.o fjd.o mod.o replace_card.o deal_cards.o print_cards.o
	gcc -o play_poker main.o user_input.o fjd.o mod.o replace_card.o deal_cards.o print_cards.o

main.o: main.s
	gcc -g -c main.s

user_input.o: user_input.s
	gcc -g -c user_input.s
	
fjd.o: fjd.s
	gcc -g -c fjd.s 
 
mod.o: mod.s
	gcc -g -c mod.s
	
deal_cards.o: deal_cards.s
	gcc -g -c deal_cards.s

replace_card.o: replace_card.c
	gcc -g -c replace_card.c
	
print_cards.o: print_cards.s
	gcc -g -c print_cards.s

clean:
	rm *.o play_poker