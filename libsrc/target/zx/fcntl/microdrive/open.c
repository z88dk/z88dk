/*
 *	Open a file on Microdrive
 *	Stefano Bodrato - Jan. 2005--2021
 *
 *	int open(char *name, int flags, mode_t mode)
 *	returns handle to file
 *
 *
 *      Flags are either:
 *
 *      O_RDONLY = 0
 *      O_WRONLY = 1   
 *      O_RDWR   = 2    
 *
 *      | with:
 *      O_APPEND = 256
 *      O_TRUNC = 512
 *
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



// If we have a RO file...
if (flags == O_RDONLY) {
	if (if1_filestatus == -1)
	{
		// FILE NOT FOUND
		free(if1_file);
		return(-1);
	}
	// Let's keep the file we already got
}



// -- From now on, we assume the file is open for writing --

// Exit if 'microdrive not present' or 'write protected' or 'Microdrive full'
if (if1_mdv_status(if1_driveno(name)) || (if1_free_sectors(if1_driveno(name))<1)) {
	free(if1_file);
	return(-1);
}



// If the file exists and the 'APPEND' flag is set..
if ((flags & O_APPEND) && (if1_filestatus != -1)) {
	// We pass a special offset value to lseek()
	// on the "open for append" event
	lseek((int)(if1_file), 999999L, SEEK_END);  // ..move to the last file record and update the pointer
}



// If we got a file but it must be truncated, let's remove it
if ((flags & O_TRUNC) && (if1_filestatus != -1)) {
	if1_remove_file(if1_driveno(name), if1_filename(name));
	if1_filestatus = -1;
}


// Let's create a file if missing
if (if1_filestatus == -1) {
	if1_touch_file(if1_driveno(name), if1_filename(name));
	if1_filestatus = if1_load_record(if1_driveno(name), if1_filename(name), 0, if1_file);
	if1_file->recflg |= 2;	// Set EOF bit
}


 return(if1_file);
}

