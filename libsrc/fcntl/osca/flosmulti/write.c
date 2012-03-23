/*
 *	Write byte from file for OSCA FLOS
 *
 *	Stefano Bodrato - March 2012
 *
 *	Not user callable - internal LIB routine
 *
 *	$Id: write.c,v 1.1 2012-03-23 13:46:51 stefano Exp $
 */

//#include <fcntl.h>

// "stdio.h" contains definition for EOF
//#include <stdio.h>
#include <flos.h>

int write(int myfile, void *buf, size_t len)
{
	struct flos_file *flosfile;

	flosfile = (char *) myfile;

	if (flosfile->mode==O_RDONLY)
		return (-1);

	if (flosfile != flos_lastfile) {
		if (flosfile->name[0]==0)
			return (-1);

		if (find_file(flosfile->name, flosfile) == 0) {
			return (-1);
		}
		flos_lastfile=flosfile;
	}
	
	if (write_bytes_to_file( (flosfile)->name, buf, get_bank(), len) != 0)
		return (-1);

	flosfile->position+=len;
	return (len);
}
