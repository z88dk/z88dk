/*
 *	long lseek(int fd, long posn, int whence)
 *
 *	Stefano Bodrato - 2013
 *
 *	0	SEEK_SET from start of file
 *	1	SEEK_CUR from current position
 *	2	SEEK_END from end of file (always -ve)
 *
 *	$Id: lseek.c,v 1.1 2014-01-14 07:48:41 stefano Exp $
*/

#include <fcntl.h>
// "stdio.h" contains definition for EOF
#define __HAVESEED
#include <stdio.h>



long lseek(int handle, long posn, int whence)
{
	struct RND_FILE *myfile;
	int blockno;

	myfile = (char *) handle;
	

	if ((myfile)->mode!=O_RDONLY)
		rnd_saveblock(&(myfile)->name_prefix, (myfile)->blockptr, (myfile)->blocksize);

	switch (whence) {
		case SEEK_SET:
			(myfile)->position=posn;
			break;
		
		case SEEK_CUR:
			(myfile)->position=(myfile)->position+posn;
			break;

		case SEEK_END:
			(myfile)->position=(myfile)->size;
			break;
	}
	
	blockno=(myfile)->position/(myfile)->size;

	if (blockno>36)
		return (EOF);

	if (blockno<10)
		(myfile)->name_prefix=blockno+'0';
	else
		(myfile)->name_prefix=blockno-10+'A';


	(myfile)->pos_in_block=(int)((myfile)->position % (myfile)->blocksize);
	if (rnd_loadblock(&(myfile)->name_prefix, (myfile)->blockptr, (myfile)->blocksize))
		return(EOF);

	return ((myfile)->position);
}
