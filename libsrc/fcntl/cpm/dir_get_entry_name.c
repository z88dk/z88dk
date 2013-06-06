/*
 *  CP/M Directory browsing
 * 
 *  Stefano, 5 Jun 2013
 *
 *
 *  $Id: dir_get_entry_name.c,v 1.1 2013-06-06 08:58:32 stefano Exp $
 */

#include <cpm.h>


char dest[20];	// temp filename buffer

int i,j;
char * source;


patch_chars (int startpos, int endpos)
{
	for (i = startpos; i < endpos; i++)
	{
		if (source[i] == ' ') break;
		dest[j++] = source[i] & 0x7F;
	}
}

char *dir_get_entry_name()
{

	source = fc_dirbuf + fc_dirpos * 32;
	j = 0;
	i = 1;

	patch_chars (1, 9);

	if (source[9] != ' ')
		dest[j++] = '.';

	patch_chars (9, 12);

	dest[j] = '\0';

	return dest;
}
