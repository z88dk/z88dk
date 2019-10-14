
/*  zcc +cpm -lndos -create-app -DAMALLOC e.c  */


/*
 * e.c - Computes e to some extraordinary number of places.
 */



#include <stdio.h>
#include <stdlib.h>



int main(int argc, char **argv)
{
	register int	i, n;
	int		lim;
	int		nterms;
	int		j;
	register int	*vec;

	if (argc > 1) {
		nterms = atoi(argv[1]);
		if (argc > 2) {
			lim = atoi(argv[2]);
		}
		else {
			fprintf(stderr, "usage %s nterms limit\n", argv[0]);
			fprintf(stderr, ".. limit set to nterms (%d)\n",
					nterms);
			lim = nterms;
		}
	}
	else {
		fprintf(stderr, "usage %s nterms limit\n", argv[0]);
		fprintf(stderr, ".. nterms and limit set to 100\n");
		nterms = lim = 100;
	}
	putchar('2');
	putchar('.');
	if ((vec = calloc(nterms+1, sizeof *vec)) == NULL) {
		fprintf(stderr, "Not enough memory\n");
		exit(1);
	}
	for (i = 2; i <= nterms; ++i)
		vec[i] = 1;
	for (j = 1; j <= lim; ++j) {
 		for (n = 0, i = nterms; i >= 2; --i) {
			n += vec[i] * 10;
			vec[i] = n % i;
			n /= i;
		}
		putchar(n+'0');
	}
	putchar('\n');
}
