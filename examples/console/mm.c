 /*
   Mastermind game, written by:	Stephen A. Ward,
				January, 1980

   Modified for BDS C by:	Leor Zolman,
				February, 1980

   Modified for Z88DK
   (and Visual C and GCC) by:	Stefano Bodrato,
				March, 2004

				
   -- NOTE:  Z88DK ports need to be extended to support shells, to be able to pass the following parameters --

   Usage:  mm [ -B ] [ -K ] [ -C# ] [ -P# ]
 
   where:  -B  tells # of possible solutions before each guess
	   -C# sets number of different characters (e.g., "-c4" means A-D)
		(defaults to 6)
	   -P# sets number of positions in solution string
		(defaults to 4)
	   -K  disables kibitzing (enabled by default.). 
		
    Thus, for example, the invokation
	   mm -C10 -P3
    would simulate the game of "Bagels", where the layout is ten different
    characters in three positions. I don't think "Bagels" allows repetitions,
    though, so it isn't QUITE the same...

*/

#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <stdio.h>
//#include <time.h>

#define	NPEGS	10		/* Max NPeg		*/
#define	MCOLORS	26		/* Max NColors		*/
#define NHIST 100

char	Secret[NPEGS+2];	/* was CHAR */
char	History[NHIST*NPEGS];	/* was CHAR */
int	Jots[NHIST];
int	guesses;
int	NColors,		/* Number of colors	*/
	NPeg;			/* Number of pegs	*/

char	KFlag,			/* Kibitz flag		*/
	BFlag;		/* Debug flag		*/


main(int argc,char **argv)
//char **argv;
 {
	register int i,j;
	int ngames, ntries;
	char *trial, *arg;

	ngames = ntries = 0;
	NColors = 6;		/* Number of colors	*/
	NPeg = 4;		/* Number of pegs	*/
	KFlag = 1;		/* Kibitz flag		*/
	BFlag = 0;		/* Debug flag		*/

	for (i=1; i<argc; i++)
	 { if (*(arg = argv[i]) == '-') switch (*++arg) {
		case 'B':	BFlag++; continue;
		case 'K':	KFlag = !KFlag; continue;
		case 'C':	NColors = atoi(++arg);
				if (NColors > MCOLORS) NColors = MCOLORS;
				continue;
		case 'P':	NPeg = atoi(++arg);
				if (NPeg > NPEGS) NPeg = NPEGS;
				continue;
		default:	printf("Illegal option %s\n",
					argv[i]); exit(-1); }
	   else
		{ printf("Usage: mm [ -b ] [ -k ] [ -c# ] [ -p# ]\n");
		  exit(-1); }}

	printf("%c",12);
	printf("Mastermind game:\n");
	printf("  I have a secret string of %d letters ",NPeg);
	printf("between A and %c.\n", 'A' + NColors - 1);
	printf("  Object: find it in as few guesses as possible.\n");
	printf("  For each guess, I will tell you how many\n");
	printf("	Hits (right letter in the right place) and\n");
	printf("	Misses (right letter in the wrong place)\n");	
	printf("  you had for that guess.\n");
	printf("  Note: letters may appear more than once in my strings.\n");

	//srand1("\nType any character to begin: ");
	//srand(time(NULL));
	printf("\nType any character to begin: ");
	getchar();

Game:
	for (i=0; i<NPeg; i++) Secret[i] = rand() % NColors;
	printf("\n\nNew game!\n");
	for (guesses=0;;guesses++)
	 { if (BFlag)
	     printf("\n   (%d possible secret symbols)\n", Check());
	   else if (KFlag && guesses && Check() == 1)
	     printf("\nYou should be able to figure it out now!\n");
	   if (!rguess("Your test symbol", trial = &History[NPeg*guesses]))
		break;

	   j = match(trial, Secret);
	   Jots[guesses] = j;

	   printf( (j>>4 ? "\t\t\t %d hit" : "\t\t\t no hit"), j>>4);
	   if ((j>>4) - 1) putchar('s');

	   printf ( (j & 0xf ? ", %d miss" : ", no miss"), j & 0xf);
	   if ((j & 0xf) - 1) printf("es");

	   putchar('\n');

	   if (j == (NPeg << 4))
		{ printf("You got it in %d guesses!\n", ++guesses); 
		  ntries += guesses;
		  ngames++;
		  i = ntries/ngames;
		  //printf("Average for %d game%c is %1d.%1d\n",
		  printf("Average for %d game%c is %d.%d\n",
			ngames,	(ngames != 1) ? 's' : 32,
			i , ntries*100 /ngames %100);
		  goto Game; }}
	Secret[NPeg] = 0;
	printf("My secret symbol was ");
	for (i=0; i<NPeg; i++) putchar('A' + Secret[i]);
	printf("\n");
	goto Game;
 }

int match(aa, bb)
 char *aa;
 char *bb;
 {	register int i, score;
	char j;
	int temp[MCOLORS];
	score = 0;
	for (i=0; i<NColors; i++) temp[i] = 0;
	for (i=0; i<NPeg; i++)
	   if ((j = aa[i]) != bb[i]) temp[j]++;
	for (i=0; i<NPeg; i++)
		{ if ((j = bb[i]) == aa[i]) score += 16;
		  else if (temp[j]-- > 0) score++; }
	return score; }

int incr(tt)
 char *tt;
 {	register int i;
	i = 0;
	while (i < NPeg)
	 { if (++tt[i] < NColors) return 1;
	   tt[i] = 0; i++; }
	return 0; }


int Check()
 {	char tt[NPEGS];
	char *hh;
	register int i, j;
	int count;
	count = 0;
	for (i=0; i<NPeg; i++) tt[i] = 0;
	do {
		hh = &(History[0]);
		for (j=0; j<guesses; j++, hh += NPeg)
			if (match(hh, tt) != Jots[j]) goto nope;
		count++;
nope:		i = i;
	   } while (incr(tt));
	return count; 
 }


int rguess(char *prompt, char *where)
 {	
 register int i, c;

again:	printf("%s:  ", prompt);
	i = strlen(gets(where));
	//i = strlen(getl(where,4));
	if (i == 0) return 0;
	if (i > NPeg && !isspace(where[i])) {
			 printf("Too many letters\n"); goto again;
	 }
	if (i < NPeg) {  printf("Too few letters\n"); goto again; }
	for (i=0; i<NPeg; i++) {
	  c = where[i] = toupper(where[i]) - 'A';
	   if (c < 0 || c >= NColors)
		{ printf("Bad letter -- use A thru %c\n", 'A'+NColors-1);
		  goto again; }
	 }
	return 1;
}
