/*
 *	Remove 'random access' pseudo file
 *  get the file details from the control block
 *  and remove all the related files
 *
 *	Stefano Bodrato - 2013
 *
 *	$Id: remove.c,v 1.1 2014-01-14 07:48:41 stefano Exp $
*/

#include <fcntl.h>


int remove(char *name)
{

struct RND_FILE *myfile;
int myfile_missing;
int blockcount;

	myfile = malloc(sizeof(struct RND_FILE));
	strcpy(myfile->name,name);
	(myfile)->name_prefix='_';

	myfile_missing = rnd_loadblock(&(myfile)->name_prefix, myfile, sizeof(myfile));
	if (myfile_missing) {
		return (-1);
	}

	rnd_erase(&(myfile)->name_prefix);

	blockcount=(int)(myfile->size/myfile->blocksize)+1;
	(myfile)->name_prefix='0';

	while (blockcount-- > 0) {
		rnd_erase(&(myfile)->name_prefix);
		if ((myfile)->name_prefix=='9') (myfile)->name_prefix='A';
		else (myfile)->name_prefix++;
	}

}
