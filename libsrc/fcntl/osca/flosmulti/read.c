/*
 *	Read from file for OSCA FLOS
 *
 *	Stefano Bodrato - March 2012
 *
 *	extern size_t __LIB__ read(int fd, void *ptr, size_t len);
 *
 *	$Id: read.c,v 1.1 2012-03-21 21:47:14 stefano Exp $
 */

#include <fcntl.h>

// "stdio.h" contains definition for EOF
#include <stdio.h>
#include <flos.h>


size_t read(int myfile, void *ptr, size_t len)
{
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

	set_load_length(len);
	if (force_load(ptr, get_bank()) != 0) return (EOF);
	flosfile->position+=len;

	return (len);

}

