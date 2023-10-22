#include <stdio.h>

void replace_card(FILE *fp, unsigned *hand, unsigned indices, unsigned uid);

void replace_card(FILE *fp, unsigned *hand, unsigned oindices, unsigned uid)
{
	unsigned index_num = 0;
	unsigned mask = 7;
	unsigned card_mask = 63;
	unsigned index;
        unsigned indices;

	do
	{
		indices = oindices >> 3*index_num;
		index = indices & mask;
		if (index != 0)
		{

			unsigned card;
			unsigned suit;
			fscanf(fp, "%u", &card);
			fscanf(fp, "%u", &suit);
			*hand = (*hand) & ~(card_mask << 6*(index-1));
            suit = suit << 4;
            card = card | suit;
			*hand = (*hand) | (card << 6*(index-1));
		}
                index_num++;
	}
	while (index != 0);


}
