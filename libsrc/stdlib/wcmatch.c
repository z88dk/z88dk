/*
 *	WildCard matching
 *
 *	$Id: wcmatch.c,v 1.2 2013-11-13 15:34:46 stefano Exp $
 */

#include <stdlib.h>


// Found in the BDS C sources, (wildexp..),written by Leor Zolman.
// contributed by: W. Earnest, Dave Hardy, Gary P. Novosielski, Bob Mathias and others

int c;

int wcmatch(char *wildnam, char *filnam)
{
   while (c = *wildnam++)
	if (c == '?')
		if ((c = *filnam++) && c != '.')
			continue;
		else
			return 0;
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
	else return 0;

   if (!*filnam)
	return 1;		// TRUE
   else
	return 0;
}
