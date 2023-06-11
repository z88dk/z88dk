/*
 *	Write a byte sequentially to Microdrive
 *
 *	Stefano Bodrato - Feb. 2021
 *
 *
 *	Not user callable - internal LIB routine
 *
 *	Enter with de = filehandle
 *
 *	$Id: writebyte.c $
*/

#include <fcntl.h>
#include <string.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <arch/zx/zxinterface1.h>

int writebyte(int fd, int byte)
{
	struct M_CHAN *if1_file;
	int 	if1_filestatus;
	//unsigned char	mychar;
	
	if1_file = (void *) fd;
	
	// Trying to write on a RO file
	if (!(if1_file)->flags)  return(-1);

	//if ( (if1_file->position != 0L) && ((int) ((if1_file->position ) % 512L) == 0L) )
	if ( (if1_file->position != 0L) && ( !if1_bytecount(if1_file->position)) )
	{
		// This will overwrite/finalize the current sector.
		if1_write_sector (if1_file->drive, if1_file->sector, if1_file);
		
		if1_file->reclen=0;
		if1_file->bytecount=0;
		
		if1_file->recnum++;
		
		//bzero (if1_file->data, 512);

		/*
		   When accessing to the Microdrive at sector level, the 'record' field
		   is used to specify the sector number to be written.
		   Let's spot a free one and assign the fresh value to the current buffer.
		*/
		if1_file->record = if1_find_sector(if1_file->drive);
		if1_file->sector = if1_file->record;
	}

	
	//if1_file->data[if1_file->bytecount] == byte;
	//*((unsigned char *) (if1_file->data + ( (int)(if1_file->position) % 512L))) = byte;
	*((unsigned char *) (if1_file->data + if1_bytecount(if1_file->position)) ) = byte;
	
	if1_file->reclen++;
	if1_file->bytecount++;
	if1_file->position++;

}
