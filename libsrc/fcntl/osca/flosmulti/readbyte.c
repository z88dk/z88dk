/*
 *	Read byte from file for OSCA FLOS
 *
 *	Stefano Bodrato - March 2012
 *
 *	Not user callable - internal LIB routine
 *
 *	$Id: readbyte.c,v 1.1 2012-03-21 10:20:23 stefano Exp $
*/

#include <fcntl.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <flos.h>


int __FASTCALL__ readbyte(int myfile)
{
	unsigned char mybyte[2];
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

		set_file_pointer(flosfile->position);
		flos_lastfile=flosfile;
	}

	set_load_length(1);
	if (force_load(mybyte, get_bank()) != 0) return (EOF);
	flosfile->position++;

	return ((unsigned char *) mybyte[0]);

}
