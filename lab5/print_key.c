#include <stdio.h>

void print_key(unsigned n);

void print_key(unsigned n){
	int key[4];
	int mask = 7;

	int i;

	for (i = 0; i < 4; i++){
		key[3-i] = n >> (3*i) & mask;
	}

	for (i = 0; i < 4; i++)
		printf("%d ", key[i]);

	printf("\n\n");
}
