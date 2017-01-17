/*
 *	Open a file - create the control block in a memory structure,
 *  allocate its temporary buffer and eventually write a first empty
 *  block on disk.   A file holding the control block plus
 *  other files will form the virtual sectors of the same rnd_file
 * 
 *	Stefano Bodrato - 2013
 *
 *	int open(char *name, int flags, mode_t mode)
 *	returns handle to file
 *
 *
 *	Access is either
 *
 *	O_RDONLY = 0
 *  (O_RDWR .. does not mean much at the)
 *	O_WRONLY = 1    Starts afresh?!?!?
 *	O_APPEND = 256
 *
 *	$Id: open.c,v 1.3 2016-06-13 19:55:47 dom Exp $
 */

#include <fcntl.h>
// "stdio.h" contains definition for EOF
#define __HAVESEED
#include <stdio.h>

#include <string.h>
#include <malloc.h>


int open(char *name, int flags, mode_t mode)
{
struct RND_FILE *myfile;
int myfile_missing;

myfile = malloc(sizeof(struct RND_FILE));
strcpy(myfile->name,name);
(myfile)->name_prefix='_';

myfile_missing = rnd_loadblock(&(myfile)->name_prefix, myfile, sizeof(struct RND_FILE));

if (myfile_missing) {
	(myfile)->size=0L;
	(myfile)->blocksize=RND_BLOCKSIZE;
}

(myfile)->position=0L;
(myfile)->blockptr=malloc((myfile)->blocksize+1);
//(myfile)->flags=flags;
(myfile)->mode=flags;
(myfile)->name_prefix='0';
(myfile)->pos_in_block=0;


switch (flags) {
	case O_RDONLY:
		if (myfile_missing) {
			// FILE NOT FOUND
			free((myfile)->blockptr);
			free(myfile);
			return(-1);
		}
		if (!rnd_loadblock(&(myfile)->name_prefix, (myfile)->blockptr, (myfile)->blocksize)) {
			return(myfile); }
		else
			return(-1);
		break;

	case O_APPEND:
		if (myfile_missing) {
			// FILE NOT FOUND
			free((myfile)->blockptr);
			free(myfile);
			return(-1);
		}
		if (lseek(myfile,0L,SEEK_END)==EOF) {
			free((myfile)->blockptr);
			free(myfile);
			return(-1);
		}
		return(myfile);
		break;


	case O_WRONLY:
		// TODO: delete file to overwrite
	case O_RDWR:
		if (myfile_missing) {
			// create the first datablock: "0<filename>" to verify 
			// we have space on disk and disk can be written
			if (rnd_saveblock(&(myfile)->name_prefix, (myfile)->blockptr, (myfile)->blocksize)) {
				// FILE CREATION ERROR
				free((myfile)->blockptr);
				free(myfile);
				return(-1);
			}
			// The control block creation ("_<filename>) is in "close.c"
		} else if (lseek(myfile,0L,SEEK_SET)==EOF) {
			free((myfile)->blockptr);
			free(myfile);
			return(-1);
		}
		return(myfile);
		break;

	}
	return(-1);
}

