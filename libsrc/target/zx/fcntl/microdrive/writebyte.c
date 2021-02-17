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
		if1_write_record (if1_file->drive, if1_file);
		if1_file->record++;
		if1_file->reclen=0;
		if1_file->bytecount=0;
		if1_file->recnum++;
		bzero (if1_file->data, 512);
		
		//DEBUG:
		//printf ("\nNext record in file: %u  ",if1_file->record + 1);
/*
		// EOF flag set ?
		if (if1_file->recflg && 1) return (EOF);
		// No, load next record
		if1_filestatus = if1_load_record(if1_file->drive, if1_file->name, ++if1_file->record, if1_file);
		
		//DEBUG:
		//printf ("  sector: %u  len: %u\n",if1_filestatus,if1_file->reclen);
		
		if (if1_filestatus == -1) return (EOF);
	*/	
	}
	//if ( ((int) (if1_file->position) % 512) >= if1_file->reclen ) return EOF;
	*((unsigned char *) (if1_file->data + ( (int)(if1_file->position++) % 512))) == byte;
	if1_file->reclen++;
	if1_file->bytecount++;
	if1_file->position++;

}
