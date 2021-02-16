/*
 *	Open a file on Microdrive
 *	Stefano Bodrato - Jan. 2005--2021
 *
 *	int open(char *name, int flags, mode_t mode)
 *	returns handle to file
 *
 *
 *	Access is either
 *
 *	O_RDONLY = 0
 *	O_WRONLY = 1    Starts afresh?!?!?
 *	O_APPEND = 256
 *
 *	$Id: open.c $
 */

#include <fcntl.h>
#include <zxinterface1.h>

//#include <stdio.h>
#include <malloc.h>


int open(char *name, int flags, mode_t mode)
{
int if1_filestatus;
struct M_CHAN *if1_file;

// TODO:  Add drive number support, (only first drive ATM)
// "1," currently is used to initializes "if1_file->drive" in struct

if1_file = malloc(sizeof(struct M_CHAN));
if (if1_file == 0) return (-1);
if1_filestatus = if1_load_record(1, (char *)name, 0, if1_file);

(if1_file)->flags=flags;
(if1_file)->mode=mode;

switch ( flags & 0xff ) {
	case O_RDONLY:
		if (if1_filestatus == -1)
		{
			// FILE NOT FOUND
			free(if1_file);
			return(-1);
		}
		/*
		    DEBUGGING: "hdname" could be useful to check if the disk has been changed
			printf("\nread only :  %u  - %s\n",if1_file, if1_getname( (char *) ((if1_file)->name)) );
			printf ("--%s--",if1_getname( (char*) ((if1_file)->hdname)) );
		*/
		// RESET FILE COUNTER
		(if1_file)->position=0;
		return(if1_file);
		break;

	case O_WRONLY:
		if (if1_filestatus != -1)
		{
			// FILE ALREADY EXISTING
			if1_remove_file(1,(char *)name);
		}
		if1_touch_file(1,(char *)name);
		if1_filestatus = if1_load_record(1, (char *)name, 0, if1_file);
		if (if1_filestatus == -1)
		{
			// FILE NOT FOUND
			free(if1_file);
			return(-1);
		}
/*		
#pragma printf %u
		if ((if1_file)->reclen >0) printf ("\n reclen: %u\n",(if1_file)->reclen);
		else  printf ("\n reclen is zero\n");
*/	
		return(if1_file);
		break;

	case O_APPEND:
		if (if1_filestatus == -1)
		{
			// FILE NOT FOUND
			free(if1_file);
			return(-1);
		}
		(if1_file)->position=0;
		(if1_file)->flags=flags;
		(if1_file)->mode=mode;
		lseek((int)(if1_file), 0, SEEK_END);
		return(if1_file);
		break;

	}
	
	free (if1_file);
	return(-1);
}

