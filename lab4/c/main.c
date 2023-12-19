#include <stdio.h>
#include <stdlib.h>
#include <time.h>

void split_deck(int p, int a[], int n);
int move(int p, int a[]);
int check_stable(int p, int a[]);
int left_shift(int p, int a[]);
int rand_gen(int lower, int upper);
void print_array(int length, int a[], int counter);


int main() {
	// Initialize variables
	srand(time(0));
	int deck[45];
	for (int i = 0; i < 45; i++)
		deck[i] = 0;
	int p = rand_gen(1, 45);
	split_deck(p, deck, 45);
	
	int counter = 0;
	print_array(45, deck, counter);

	while (!check_stable(p, deck)) {
		p = move(p, deck);
		counter++;
		print_array(45, deck, counter);
	}
	return 0;
}

int rand_gen(int lower, int upper) {
	return (rand() % (upper - lower + 1)) + lower;
}

int check_stable(int p, int a[]) {
	if (p != 9)
		return 0;
	else {
		int i = 0;
		while (i < 8) {
			if (a[i] == a[i + 1] - 1)
				i++;
			else
				return 0;
		}
		return 1;
	}
}

void split_deck(int p, int a[], int n) {
	int i = 0;
	while (i < p - 1) {
		int x = rand_gen(1, n - p + i + 1);
		a[i] = x;
		n = n - x;
		i++;
	}
	a[i] = n;
}

int left_shift(int p, int a[]) {
	int i = 0;
	while (i < p) {
		if (a[i] == 0) {
			for (int j = (i + 1); j < p + 1; j++)
				a[j - 1] = a[j];
			a[--p] = 0;
		}
		i++;
	}
	return p;
}

int move(int p, int a[]) {
	int total = 0;
	int i = 0;
	while (i < p) {
		if (a[i] != 0) {
			total++;
			a[i]--;
			if (a[i] == 0)
				p = left_shift(p, a);
			else
				i++;
		}
		else
			p = left_shift(p, a);
	}
	a[p] = total;
	++p;
	return p;
}

void print_array(int length, int a[], int counter) {
	printf("%d:", counter);
	for (int i = 0; i < length; i++)
		if (a[i] != 0)
			printf("%d ", a[i]);
	printf("\n");
}
