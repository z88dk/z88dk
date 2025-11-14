/*
 *	Read byte from file in Microdrive
 *
 *	Stefano Bodrato - Feb. 2005
 *
 *
 *	Not user callable - internal LIB routine
 *
 *	Enter with de = filehandle
 *
 *	$Id: readbyte.c $
*/

#include <fcntl.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <arch/zx/zxinterface1.h>


int readbyte(int fd)
{
	struct M_CHAN *if1_file;
	int 	if1_filestatus;
	
	if1_file = (void *) fd;

	if ( if1_recnum(if1_file->position) > if1_file->record )
	{

		// EOF flag set ?
		if (if1_file->recflg && 1) return (EOF);
		// No, load next record
		if1_filestatus = if1_load_record(if1_file->drive, if1_file->name, ++if1_file->record, if1_file);
		
		if (if1_filestatus == -1) return (EOF);
		
	}
	if ( if1_bytecount(if1_file->position) >= if1_file->reclen ) return EOF;

	return ( *(unsigned char *) (if1_file->data + if1_bytecount(if1_file->position++)) );

}
