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
 *	$Id: readbyte.c,v 1.2 2005-03-01 17:50:37 stefano Exp $
*/

//#include <fcntl.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <zxinterface1.h>


int __FASTCALL__ readbyte(int handle)
{
	struct M_CHAN *if1_file;
	int 	if1_filestatus;
	//unsigned char	mychar;
	
	if1_file = (char *) handle;
	//printf ("-- reading '%s' - %u --",if1_getname( (char *) if1_file->hdname ), handle);

	if ( (int) (if1_file->position / 512) > if1_file->record )
	{
		//DEBUG:
		//printf ("\nNext record in file: %u  ",if1_file->record + 1);

		// EOF flag set ?
		if (if1_file->recflg && 1) return (EOF);
		// No, load next record
		if1_filestatus = if1_load_record(if1_file->drive, if1_file->name, ++if1_file->record, if1_file);
		
		//DEBUG:
		//printf ("  sector: %u  len: %u\n",if1_filestatus,if1_file->reclen);
		
		if (if1_filestatus == -1) return (EOF);
		
	}
	if ( ((int) (if1_file->position) % 512) >= if1_file->reclen ) return EOF;

	return ( (unsigned char *) *(if1_file->data + ( (int)(if1_file->position++) % 512)) );

}
