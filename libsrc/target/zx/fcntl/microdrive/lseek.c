/*
 *	long lseek(int fd, long posn, int whence)
 *
 *	Stefano Bodrato - Feb. 2005
 *	Needs optimizations: always re-reads the record
 *
 *	0	SEEK_SET from start of file
 *	1	SEEK_CUR from current position
 *	2	SEEK_END from end of file (always -ve)
 *
 *	$Id: lseek.c $
 */

#include <fcntl.h>
#include <stdio.h>
#include <zxinterface1.h>


long lseek(int handle, long posn, int whence)
{
	
	struct	M_CHAN *if1_file;
	int 	if1_filestatus;
	long	position;
	int		flags;
	int		sector;
	
	
	if1_file = (void *) handle;
	flags = (if1_file)->flags & 0xff;
	
	
	// Let's begin by moving to the file tail if necessary
	if (whence == SEEK_END) {
		if ((posn != 999999L) && (flags == O_WRONLY))
			if1_write_sector (if1_file->drive, if1_file->sector, if1_file);
		
		if1_filestatus = if1_load_record(if1_file->drive, if1_file->name, 0, if1_file);
		// Move up to end of file
		while ((if1_file->recflg & 2) == 0) {
			sector = if1_file->sector;
			if1_filestatus = if1_load_record(if1_file->drive, if1_file->name, ++if1_file->record, if1_file);
			// Fix a possibly missing EOF
			if (if1_filestatus == -1) {
				if1_filestatus = if1_load_sector(if1_file->drive, sector, if1_file);
				if1_file->recflg |= 2;
			}
		}
		// Now get the latest position and add the offest
		if1_file->position = (long) if1_file->record * 512L + (long) if1_file->reclen;
		if1_file->recflg &= 0xFD;	// Reset EOF bit
	}

	
	// Force a static positioning if requested
	if (whence == SEEK_SET)
		position = posn;
	else {
		// SEEK_CUR
		// SEEK_END (finalizing)
		// Relative positioning, 999999L is a 'flag' used when opening for append
		position = if1_file->position;
		if ((posn != 0L) || (posn != 999999L))
			position += posn;
	}


	// Overflow ?
	if ((position < 0L)|| (position > if1_file->position))
		return (-1);

	
	// Are we moving to a different sector ?
	if ((position % 512L) != ((if1_file->position ) % 512L)) {
		// If we're in WRITE or APPEND mode, let's save the current file record
		if (flags == O_WRONLY) {
			// Set the EOF bit if we are moving away from the last record
			if (position < if1_file->position)
				if1_file->recflg |= 2;
			if1_write_sector (if1_file->drive, if1_file->sector, if1_file);
		}
		// Now let's pick the new file record, (needed both for READing/WRITing)
		if1_load_record(if1_file->drive, if1_file->name, (int)(posn / 512L), if1_file);
			// Here we could fine-tune the internal record pointers
			// ATM we're using the if1_file->position everywhere, so this is not mandatory
	}

	return (if1_file->position = position);
}
