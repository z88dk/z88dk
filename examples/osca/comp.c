/* comp - compare two files
 * Converted from the BDS C version
 * by Stefano Bodrato - 27/3/2012
 * 
 * zcc +osca -lflosxdos comp.c
 * 
 * $Id: comp.c,v 1.2 2013-06-06 11:42:46 stefano Exp $
 * 
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <ctype.h>

int line = 1, block = 0, lflag = 0, pflag=0, charn = -1;
long pos=-1L;
FILE *f1;
FILE *f2;
int x,c,d;
char fn1[30];
char fn2[30];

main(int argc, char *argv[])
{
	if ((argc < 3) || (argc > 4)) {
		printf("Usage: COMP [/L] file1 file2\n"); 
		exit(0);
	}

	for (x=1; x<argc; x++) {
		if (strcmp(argv[x],"/L")==0) lflag++;
		else {
			if (pflag==0) {
				strcpy(fn1,argv[x]);
				f1=fopen(fn1,"rb");
				pflag++;
			} else {
				strcpy(fn2,argv[x]);
				f2=fopen(fn2,"rb");
			}
		}
	}

	if (f1==NULL) {
		printf("Can't open first file: %s\n",fn1);
		exit(0);
	}

	if (f2==NULL) {
		printf("Can't open second file: %s\n",fn2);
		exit(0);
	}

	while (1) {
		if (++charn == SECSIZE) { block++ ;charn = 0; }
		pos++;
		c = getc(f1); d = getc(f2);
		if (c == '\n') line++;
		if (c == d) {
			if (c < 0) {
				if (lflag <= 1) 
					printf("Files are identical.\n");
				exit(0); }
			continue; }
		if (c < 0) {printf("%s is shorter.\n",fn1); exit(0); }
		if (d < 0) {printf("%s is shorter.\n",fn2); exit(0); }
		if (lflag) {
			printf("%s pos %lu char %u block %u line %u = %u; %s = %u\n",
										fn1,pos,charn,block,line,c,fn2,d);
			lflag = 2;
			continue; }
		printf("Files differ at position %lu, character %u, block %u, line %u.\n",
										pos,charn,block,line);
		exit(0); }
}
