/*
 *  OSCA demo
 *  New sample command for FLOS,
 *	decimal directory listing
 * 
 * Stefano Bodrato, 3/8/2011
 * 
 * $Id: ddir.c,v 1.1 2011-08-03 08:13:40 stefano Exp $
 * 
 */


#include <stdio.h>
#include <string.h>
#include <flos.h>

int x,y;
unsigned long sz,tot,subtot;
char output[15];

main()
{
	tot=0;
	x=dir_move_first();
	while (x == 0) {
		printf("%s ",dir_get_entry_name());
		for (y=14;y>strlen(dir_get_entry_name());y--)
			fputc_cons(' ');
		if (!dir_get_entry_type()) {
			sz=dir_get_entry_size();
			sprintf(output,"%lu",sz);
			for (y=13;y>strlen(output);y--)
				fputc_cons('.');
			printf("%s\n",output);
			tot = tot+sz;
		} else {
			printf ("<dir>\n");
		}
		x = dir_move_next();
	}
	
	printf("Total bytes: %lu.\n",tot);
}
