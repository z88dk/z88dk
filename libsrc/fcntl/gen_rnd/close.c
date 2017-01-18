/*
 *	Close a file
 *	Stefano Bodrato - 2013
 *
 *	int close(int handle)
 *  (write the current block and the control block amd free memory)
 *
 *	$Id: close.c,v 1.2 2014-01-20 09:15:31 stefano Exp $
 */

#include <fcntl.h>
#include <malloc.h>

int close(int handle)
{
	struct RND_FILE *myfile;

	myfile = (char *) handle;
	//if (!(myfile)->blockptr) return -1;

	if ((myfile)->mode!=O_RDONLY) {

		if ((myfile)->name_prefix=='_')
			return (-1);

		rnd_saveblock(&(myfile)->name_prefix, (myfile)->blockptr, (myfile)->blocksize);
		// We could check the result for rnd_saveblock, but perhaps it'd be too late
		// Let's just save the control block (hoping we won't run out of space :S)
		(myfile)->name_prefix='_';
		rnd_saveblock(&(myfile)->name_prefix, myfile, sizeof(struct RND_FILE));
	}

	free((myfile)->blockptr);
	//(myfile)->blockptr=0;
	free(myfile);

    return 0;

}

