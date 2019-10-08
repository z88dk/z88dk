/*
 *	MIOSYS C compatibility functions
 *	Stefano Bodrato - 2019
 *
 *  Addext is used to add a default file extension to a file specification if the file specification in question
 *  does not already contain an extension. It is useful for automatically adding standard extensions to files 
 *  (i.e. CCC, CMD, TXT, ...) to minimize the input necessary in command lines.
 *
 *  Return Code:  A pointer to the filespec is returned.
 *
 *  Warnings:  The filespec argument must be a character array of at least dimension 15 to avoid writing beyond the end of the string.
 *
 *
 *	$Id: addext.c $
 *
 */

#include <trsdos.h>

#include <ctype.h>
#include <string.h>


char *addext(char *filespec, char *ext)
{
	int x;
	
	for (x=0; x<strlen(filespec); x++)
		if ((filespec[x]=='/') && isalnum(filespec[x+1]))
			return (filespec);

	return (strcat(strcat(filespec,"/"),ext));
}

