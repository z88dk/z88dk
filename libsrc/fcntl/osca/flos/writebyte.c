/*
 *	Write byte from file for OSCA FLOS
 *
 *	Stefano Bodrato - March 2012
 *
 *	Not user callable - internal LIB routine
 *
 *	$Id: writebyte.c,v 1.2 2012-03-21 10:20:23 stefano Exp $
 */

//#include <fcntl.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <flos.h>

int writebyte(int myfile, int byte)
{
	struct flos_file *flosfile;

	flosfile = (void *) myfile;
	if (flosfile->name[0]==0)
		return (-1);

	if (write_bytes_to_file( (flosfile)->name, &byte, get_bank(), 1) != 0)
		return (-1);
	flosfile->position++;
	
	return (byte);
}
