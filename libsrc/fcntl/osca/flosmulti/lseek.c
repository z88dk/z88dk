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
 *	$Id: lseek.c,v 1.1 2012-03-21 10:20:23 stefano Exp $
*/

#include <fcntl.h>
#include <flos.h>

#include <stdio.h>

long lseek(int myfile, long posn, int whence)
{
	long	posit;
	struct flos_file *flosfile;

	flosfile = (char *) myfile;

	if (flosfile->mode!=O_RDONLY)
		return (-1);

	if (flosfile != flos_lastfile) {
		if (flosfile->name[0]==0)
			return (-1);

		if (find_file(flosfile->name, flosfile) == 0) {
			return (-1);
		}
	}

	posit = (flosfile)->position;

	if (find_file(flosfile->name, flosfile) == 0) {
		return (-1);
	}
	
	switch (whence) {
		case SEEK_SET:
			posit = posn;
			break;
		
		case SEEK_CUR:
			posit = posit + posn;
			break;

		case SEEK_END:
			posit = (flosfile)->size;
			break;
	}
	set_file_pointer(posit);
	//set_load_length(1);
	(flosfile)->position=posit;
	return(posit);
}
