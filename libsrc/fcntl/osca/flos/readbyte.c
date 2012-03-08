/*
 *	Read byte from file for OSCA FLOS
 *
 *	Stefano Bodrato - March 2012
 *
 *	Not user callable - internal LIB routine
 *
 *	$Id: readbyte.c,v 1.1 2012-03-08 07:16:46 stefano Exp $
*/

//#include <fcntl.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <flos.h>


int __FASTCALL__ readbyte(int myfile)
{
	unsigned char mybyte[2];
	struct flos_file *flosfile;

	flosfile = (char *) myfile;
	if (flosfile->name[0]==0)
		return (-1);

	if (force_load(mybyte, get_bank()) != 0) return (EOF);
	flosfile->position++;
	set_load_length(1);

	return ((unsigned char *) mybyte[0]);

}
