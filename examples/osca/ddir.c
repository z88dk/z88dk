/*
 *  OSCA demo
 *  New sample command for FLOS,
 *	decimal directory listing
 * 
 * Stefano Bodrato, 3/8/2011
 * 
 * $Id: ddir.c,v 1.2 2012-02-17 07:51:47 stefano Exp $
 * 
 */


#include <stdio.h>
#include <string.h>
#include <flos.h>
#define TRUE 1
#define FALSE 0

int x,y,lines;
char c,p,w,filtered;
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
		if ((!filtered) || match(wildname,dir_get_entry_name())) {
			printf("%s ",dir_get_entry_name());
			for (y=14;y>strlen(dir_get_entry_name());y--)
				fputc_cons(' ');
			if (!dir_get_entry_type()) {
				sz=dir_get_entry_size();
				sprintf(output,"%lu",sz);
				if (w) {
						printf (" |   ");
				} else {
					for (y=13;y>strlen(output);y--)
						fputc_cons('.');
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
		if (p && (lines>23)) {
			printf (" --more-- ");
			fgetc_cons();
			fputc_cons('\n');
			lines=0;
		}
			
		x = dir_move_next();
	}
	
	if (!w) {
		printf("Total bytes: %lu.",tot);
	}
	fputc_cons('\n');
	return(0);
}


int match(char *wildnam, char *filnam)
{
   while (c = *wildnam++)
	if (c == '?')
		if ((c = *filnam++) && c != '.')
			continue;
		else
			return FALSE;
	else if (c == '*')
	{
		while (c = *wildnam)
		{ 	wildnam++;
			if (c == '.') break;
		}
		while (c = *filnam)
		{	filnam++;
			if (c == '.') break;
		}
	}
	else if (c == *filnam++)
	 	continue;
	else return FALSE;

   if (!*filnam)
	return TRUE;
   else
	return FALSE;
}
