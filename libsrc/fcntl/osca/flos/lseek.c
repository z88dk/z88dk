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
 *	$Id: lseek.c,v 1.1 2012-03-08 07:16:46 stefano Exp $
*/

#include <fcntl.h>
#include <stdio.h>
#include <flos.h>


long lseek(int myfile, long posn, int whence)
{
	long	position;
	char	myname[14];
	struct flos_file *flosfile;

	flosfile = (char *) myfile;
	strcpy (myname, (flosfile)->name);
	position = (flosfile)->position;
	if (find_file(myname, flosfile) == 0) {
		flosfile->name[0]=0;
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
