/*  OSCA FLOS fcntl lib
 * 
 *	long lseek(int fd, long posn, int whence)
 *
 *	Stefano Bodrato - March 2012
 *
 *	0	SEEK_SET from start of file
 *	1	SEEK_CUR from current position
 *	2	SEEK_END from end of file (always -ve)
 *
 *	$Id: lseek.c,v 1.2 2012-03-21 10:20:23 stefano Exp $
*/

#include <fcntl.h>
#include <stdio.h>
#include <flos.h>


long lseek(int myfile, long posn, int whence)
{
	long	position;
	struct flos_file *flosfile;

	flosfile = (void *) myfile;

	position = (flosfile)->position;
	
	if (find_file(flosfile->name, flosfile) == 0) {
		return (-1);
	}
	
	switch (whence) {
		case SEEK_SET:
			position = posn;
			break;
		
		case SEEK_CUR:
			position = position + posn;
			break;

		case SEEK_END:
			position = (flosfile)->size;
			break;
	}
	set_file_pointer(position);
	set_load_length(1);
	(flosfile)->position=position;
	return(position);
}
