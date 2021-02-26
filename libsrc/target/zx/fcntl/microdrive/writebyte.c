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
#include <zxinterface1.h>

int writebyte(int fd, int byte)
{
	struct M_CHAN *if1_file;
	int 	if1_filestatus;
	//unsigned char	mychar;
	
	if1_file = (void *) fd;
	//printf ("-- reading '%s' - %u --",if1_getname( (char *) if1_file->hdname ), fd);

	if ( (if1_file->position != 0L) && ((int) ((if1_file->position ) % 512) == 0) )
	{
		//if1_write_record (if1_file->drive, if1_file);
		if1_file->recflg &= 0xFD ;	// Reset EOF bit on current record
		// This will overwrite/finalize the current sector.
		if1_write_sector (if1_file->drive, if1_file->sector, if1_file);
		
		// TODO:  append the new blank sector
		
		if1_file->reclen=0;
		if1_file->bytecount=0;
		//if1_file->record++;  <-- this is probably a sector number
		if1_file->recnum++;
		bzero (if1_file->data, 512);
	}
	
	
	//if1_file->data[if1_file->bytecount] == byte;
	*((unsigned char *) (if1_file->data + ( (int)(if1_file->position) % 512))) = byte;
	
	if1_file->reclen++;
	if1_file->bytecount++;

		//fputc_cons ('|');
		//fputc_cons ( *(unsigned char *) (if1_file->data + ( (int)(if1_file->position) % 512)) );
	
	if1_file->position++;

}
