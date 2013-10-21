#include <sound.h>
#include <stdio.h>

int main()
{
	int i;


	for (i=0; i < 8 ; i++ ) {
		printf("bit_fx(%u)\n",i);
		bit_fx(i);
	}
	for (i=0; i < 8 ; i++ ) {
		printf("bit_fx2(%u)\n",i);
		bit_fx2(i);
	}
	for (i=0; i < 8 ; i++ ) {
		printf("bit_fx3(%u)\n",i);
		bit_fx3(i);
	}
	for (i=0; i < 8 ; i++ ) {
		printf("bit_fx4(%u)\n",i);
		bit_fx4(i);
	}
}
