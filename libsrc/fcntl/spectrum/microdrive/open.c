/*
 *	Open a file on Microdrive
 *	Stefano Bodrato - Jan. 2005
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
 *	$Id: open.c,v 1.4 2016-06-13 19:55:47 dom Exp $
 */

#include <fcntl.h>
#include <zxinterface1.h>

//#include <stdio.h>
#include <malloc.h>


int open(char *name, int flags, mode_t mode)
{
int if1_filestatus;
struct M_CHAN *if1_file;


//if (if1_file = malloc(sizeof(struct M_CHAN)) == 0)
//	return (-1);

if1_file = malloc(sizeof(struct M_CHAN));
if (if1_file == 0) return (-1);
if1_filestatus = if1_load_record(1, (char *)name, 0, if1_file);

switch (mode) {
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
		(if1_file)->flags=flags;
		(if1_file)->mode=mode;
		return(if1_file);
		break;

	case O_WRONLY:
		if (if1_filestatus != -1)
		{
			//printf("\nfile already exists\n");
			free(if1_file);
			return(-1);
		}
		return(-1);	// not still implemented
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
		lseek((if1_file), 0, SEEK_END);
		break;

	}
	return(-1);
}

