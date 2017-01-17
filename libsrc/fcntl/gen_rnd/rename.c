/*
 *	Rename 
 *
 *
 *	$Id: rename.c,v 1.1 2014-01-14 07:48:41 stefano Exp $
 */

#include <fcntl.h>


int rename(char *oldname, char *newname)
{

struct RND_FILE *myfile;
int myfile_missing;
int blockcount;

	myfile = malloc(sizeof(struct RND_FILE));
	strcpy(myfile->name,newname);
	(myfile)->name_prefix='_';

	myfile_missing = rnd_loadblock(&(myfile)->name_prefix, myfile, sizeof(myfile));
	if (!myfile_missing) {
		return (-1);
	}

	strcpy(myfile->name,oldname);
	myfile_missing = rnd_loadblock(&(myfile)->name_prefix, myfile, sizeof(myfile));
	if (myfile_missing) {
		return (-1);
	}

	rnd_erase(&(myfile)->name_prefix);
	strcpy(myfile->name,newname);
	rnd_writeblock(&(myfile)->name_prefix, myfile, sizeof(myfile));

	(myfile)->name_prefix='0';
	while (!myfile_missing) {
		strcpy(myfile->name,oldname);
		myfile_missing = rnd_loadblock(&(myfile)->name_prefix, myfile, sizeof(myfile));
		strcpy(myfile->name,newname);
		rnd_writeblock(&(myfile)->name_prefix, myfile, sizeof(myfile));
		rnd_erase(&(myfile)->name_prefix);
		if ((myfile)->name_prefix=='9') (myfile)->name_prefix='A';
		else (myfile)->name_prefix++;
	}

}
