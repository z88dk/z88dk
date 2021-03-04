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
 *	O_RDWR   = 2
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


// Exit if 'microdrive not present'
if (if1_mdv_status(if1_driveno(name)) == 2) return (-1);

if1_file = malloc(sizeof(struct M_CHAN));
if (if1_file == 0) return (-1);
if1_filestatus = if1_load_record(if1_driveno(name), if1_filename(name), 0, if1_file);

(if1_file)->flags=flags;
(if1_file)->mode=mode;

// RESET FILE POINTER
(if1_file)->position=0L;



// If the file exists and the 'APPEND' flag is set..
if ((flags & O_APPEND) && (if1_filestatus != -1)){
	// We pass a special offset value to lseek()
	// on the "open for append" event
	lseek((int)(if1_file), 999999L, SEEK_END);
	return(if1_file);
}



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


	// We get here also to 'APPEND' to a non-existing file ( flags & 0xff ) 
	case O_WRONLY:
	case O_RDWR:
	
		// Exit if 'microdrive not present' or 'write protected' or 'Microdrive full'
		if (if1_mdv_status(if1_driveno(name)) || (if1_free_sectors(if1_driveno(name))<1))
		{
			free(if1_file);
			return(-1);
		}

		// If we got the file already..
		if (if1_filestatus != -1)
		{
			if (flags & O_RDWR)
				return(if1_file);

			if (flags & O_WRONLY)
				// FILE ALREADY EXISTING
				if1_remove_file(if1_driveno(name), if1_filename(name));
		}

		// let's create a new file
		if1_touch_file(if1_driveno(name), if1_filename(name));
		if1_filestatus = if1_load_record(if1_driveno(name), if1_filename(name), 0, if1_file);
		if1_file->recflg |= 2;	// Set EOF bit

		return(if1_file);
		break;
		
	}

	
	free (if1_file);
	return(-1);
}

