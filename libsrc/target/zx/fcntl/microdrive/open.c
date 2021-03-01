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

// #include <debug.h>

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

// RESET FILE POINTER
(if1_file)->position=0L;


switch ( flags & 0xff ) {
	case O_RDONLY:
		if (if1_filestatus == -1)
		{
			// FILE NOT FOUND
			free(if1_file);
			return(-1);
		}

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
		/*
		if (if1_filestatus == -1)
		{
			// FILE NOT FOUND
			free(if1_file);
			return(-1);
		}
		*/

		if1_file->recflg &= 0xFD;	// Reset EOF bit		
		return(if1_file);
		break;

	case O_APPEND:
		if (if1_filestatus == -1)
		{
			if1_touch_file(1,(char *)name);
			if1_filestatus = if1_load_record(1, (char *)name, 0, if1_file);
			/*
			if (if1_filestatus == -1)
			{
				// FILE NOT FOUND
				free(if1_file);
				return(-1);
			}
			*/
		} else
			lseek((int)(if1_file), 0, SEEK_END);
		
		if1_file->recflg &= 0xFD;	// Reset EOF bit		
		return(if1_file);
		break;
	}
	
	free (if1_file);
	return(-1);
}

