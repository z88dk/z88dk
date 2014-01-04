/*
 *	WildCard matching
 *
 *	$Id: wcmatch.c,v 1.3 2014-01-04 18:52:59 aralbrec Exp $
 */

#include <stdlib.h>


// Found in the BDS C sources, (wildexp..),written by Leor Zolman.
// contributed by: W. Earnest, Dave Hardy, Gary P. Novosielski, Bob Mathias and others

int wcmatch(char *wildnam, char *filnam)
{
   static int c;
   
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
