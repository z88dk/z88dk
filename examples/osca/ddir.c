/*
 *  DDIR - Decimal Directory
 *  New sample command for FLOS, MS-DOS style directory listing.
 *  It can be built for CP/M as well, but in that case the file
 *  size is expanded to the last disk block boundary.
 * 
 *  File size is shown in decimal, using the long data types.
 *  /P and /W arguments are supported as well as the wildcards.
 * 
 *  To support native printer output the CP/M lib must be rebuilt
 *  in DEVICES mode.  It will permit to redirect the output to "LST:"
 *  
 * 
 *  To build:
 *  zcc +osca -lndos -o ddir.exe ddir.c
 *  zcc +osca -lflosdos -o ddir.exe ddir.c  (support file output redirection)
 *  zcc +cpm -o ddir.cpm ddir.c
 * 
 *  Stefano Bodrato, 3/8/2011
 * 
 *  $Id: ddir.c,v 1.4 2013-06-06 11:42:46 stefano Exp $
 * 
 */


#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int x,y,lines;
char p,w,filtered;
unsigned long sz,tot,subtot;
char output[15];
char wildname[15];

int main(int argc, char *argv[])
{
	w=0;
	p=0;
	filtered=0;
	lines=1;
	if (argc > 1) {
		for (x=1; x<argc; x++) {
			if (!strcmp(argv[x],"/W")) w++;
			else
			if (!strcmp(argv[x],"/P")) p++;
			else {
				sprintf(wildname,argv[x]);
				filtered++;
			}
		}
	}
	tot=0;
	if ((x=dir_move_first())!=0) return(x);
	printf("-- Directory of volume #%u --\n", get_current_volume());
	while (x == 0) {
		if ((!filtered) || wcmatch(wildname,dir_get_entry_name())) {
			printf("%s ",dir_get_entry_name());
			for (y=14;y>strlen(dir_get_entry_name());y--)
				putchar(' ');
			if (!dir_get_entry_type()) {
				sz=dir_get_entry_size();
				sprintf(output,"%lu",sz);
				if (w) {
						printf (" |   ");
				} else {
					for (y=13;y>strlen(output);y--)
						putchar('.');
					printf("%s\n",output);
				}
				tot = tot+sz;
			} else {
				if (w) {
						printf ("d|   ");
				} else
					printf ("<dir>\n");
			}
			lines++;
		}
		if (isatty(stdout)) {
			if (p && (lines>23)) {
				puts_cons (" --more-- ");
				fgetc_cons();
				fputc_cons('\n');
				lines=0;
			}
		} else {
			if (p && (lines>60)) {
				putchar(12);	// Form Feed
				putchar('\n');
				lines=0;
			}
		}
		
			
		x = dir_move_next();
	}
	
	if (!w) {
		printf("Total bytes: %lu.",tot);
	}
	putchar('\n');
	return(0);
}
