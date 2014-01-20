/*
 *	Read byte - Generic RND file access lib
 *
 *	Stefano Bodrato - 2013
 *
 *
 *	Not user callable - internal LIB routine
 *
 *
 *	$Id: readbyte.c,v 1.2 2014-01-20 09:15:31 stefano Exp $
*/

#include <fcntl.h>
// "stdio.h" contains definition for EOF
#define __HAVESEED
#include <stdio.h>


int __FASTCALL__ readbyte(int handle)
{
	struct RND_FILE *myfile;
	unsigned char mybyte;
	
	myfile = (char *) handle;

	if ( (myfile)->position > (myfile)->size )
			return (EOF);
	
	mybyte = *((myfile)->pos_in_block + (myfile)->blockptr);

	if ( (myfile)->pos_in_block > (myfile)->blocksize )
	{
		if ((myfile)->name_prefix='Z')
			return (EOF);

		// TODO : add a save_block here when we are in RDWR mode

		if ((myfile)->name_prefix=='9') (myfile)->name_prefix='A';
		else (myfile)->name_prefix++;

		//if ((myfile)->name_prefix=='_')
		//	return (EOF);

		if (rnd_loadblock(&(myfile)->name_prefix, (myfile)->blockptr, (myfile)->blocksize))
			return (EOF);
		(myfile)->pos_in_block=-1;
	}
	
	(myfile)->position++;
	(myfile)->pos_in_block++;
	
	return (mybyte);

}
