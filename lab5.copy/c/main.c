#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

#define B 1
#define G 2
#define O 3
#define P 4
#define R 5
#define Y 6

void generate_key(int key[]);
void get_guess(int round, char guess[]);
void digest(char guess[]);
int find_correct_color(char guess[], int key[]);
int find_correct(char guess[], int key[], int* win);
void print_game(int white, int black);
int rand_gen(int lower, int upper);

int main() {
	// Seed random number generator
	srand(time(0));

	int key[5];
	char guess[5];
	int win = 0;

	// Generate random code
	generate_key(key);
	int i = 0;

	while (!win && i < 10) {
		get_guess(i, guess);
		int white = find_correct_color(guess, key);
		int black = find_correct(guess, key, &win);
		print_game(white, black);
		i++;
	}
	if (win)
		printf("You won!\n");
	else
		printf("You lost!\n");

	return 0;
}

int rand_gen(int lower, int upper) {
	int num = (rand() % (upper - lower + 1)) + lower;
	return num;
}

void generate_key(int key[]) {
	int i = 0;
	while (i < 4){
		key[i] = rand_gen(1, 5);
		printf("%d", key[i]);
		i++;
	}
	printf("\n");
}

void get_guess(int round, char guess[]) {
	printf("Guess %d:", round);
	scanf("%s", guess);
	digest(guess);
}

void digest(char guess[]) {
	int i = 0;
	while (i < 4) {
		char c = 0;
		switch (guess[i]) {
		case 66:
			c = B;
			break;
		case 71:
			c = G;
			break;
		case 79:
			c = O;
			break;
		case 80:
			c = P;
			break;
		case 82:
			c = R;
			break;
		case 89:
			c = Y;
			break;
		}
		guess[i] = c;
		i++;
	}
}

int find_correct_color(char guess[], int key[]) {
	int i = 0;
	int j = 0;
	int white = 0;
	while (i < 4) {
		while (j < 4) {
			if (guess[i] == key[j]) {
				if (i == j) {
					j++;
					continue;
				}
				if (guess[j] == key[j]) {
					j++;
					break;
				}
				white++;
			}
			j++;
		}
		j = 0;
		i++;
	}
	return white;
}

int find_correct(char guess[], int key[], int* win) {
	int i = 0;
	int black = 0;
	while (i < 4) {
		if (guess[i] == key[i]) {
			black++;
		}
		if (i == 3 && black == 4)
			*win = 1;
		i++;
	}
	return black;
}

void print_game(int white, int black) {
	printf("%d correct color(s) in the correct location\n%d correct color(s) in the wrong location\n", black, white);
}
