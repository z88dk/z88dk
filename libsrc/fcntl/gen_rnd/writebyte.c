/*
 *	Read byte - Generic RND file access lib
 *
 *	Stefano Bodrato - 2013
 *
 *
 *	Not user callable - internal LIB routine
 *
 * 
 *      writebyte(int fd, int c) - Read byte from file
 * 
 * -----
 * $Id: writebyte.c,v 1.2 2014-01-20 09:15:31 stefano Exp $
 */


#include <fcntl.h>
// "stdio.h" contains definition for EOF
#define __HAVESEED
#include <stdio.h>


int writebyte(int handle, int byte)
{
	struct RND_FILE *myfile;
	
	myfile = (char *) handle;

	if ( (myfile)->mode == O_RDONLY)
			return (EOF);
	
	*((myfile)->pos_in_block + (myfile)->blockptr)=byte;
	

	if ( (myfile)->pos_in_block > (myfile)->blocksize )
	{
		if ((myfile)->name_prefix='Z')
			return (EOF);
		if (rnd_saveblock(&(myfile)->name_prefix, (myfile)->blockptr, (myfile)->blocksize))
			return (EOF);

		if ((myfile)->name_prefix=='9') (myfile)->name_prefix='A';
		else (myfile)->name_prefix++;

		//if ((myfile)->name_prefix=='_')
		//	return (EOF);

		//if (rnd_loadblock(&(myfile)->name_prefix, (myfile)->blockptr, (myfile)->blocksize)) {
		//	(myfile)->pos_in_block=0;
		//}
		
		(myfile)->pos_in_block=-1;
	}
	
	(myfile)->position++;
	if ( (myfile)->position > (myfile)->size )
		(myfile)->size=(myfile)->position;
	(myfile)->pos_in_block++;

	return (0);

}

