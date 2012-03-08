/*
 *	Open a file on OSCA - BASIC FLOS mode
 *	Stefano Bodrato - March 2012
 *
 *	int open(char *name, int flags, mode_t mode)
 *	returns handle to file
 *
 *
 *	Access is either
 *
 *	O_RDONLY = 0
 *	O_WRONLY = 1    Starts afresh?!?!?
 *	O_APPEND = 256
 *
 *	$Id: open.c,v 1.1 2012-03-08 07:16:46 stefano Exp $
 */

#include <fcntl.h>
#include <flos.h>
#include <string.h>

//#include <stdio.h>
//#include <malloc.h>

struct flos_file flosfile;

int open(far char *name, int flags, mode_t mode)
{
	
if (flosfile->name[0]!=0)
	return (-1);
	

switch (mode) {
	case O_RDONLY:
		if (find_file(name, flosfile) == 0) {
			flosfile->name[0]=0;
			return (-1);
		}
		set_load_length(1);
		return(flosfile);
		break;

	case O_WRONLY:
		if (find_file(name, flosfile) != 0)
			erase_file(name);
		create_file(name);
		
		if (find_file(name, flosfile) == 0) {
			flosfile->name[0]=0;
			return (-1);
		}
		return(flosfile);
		break;

	case O_APPEND:
		if (find_file(name, flosfile) == 0) {
			flosfile->name[0]=0;
			flosfile->position=flosfile->size-1;
			set_load_length(1);
			return (-1);
		}
		return(flosfile);
		break;

	}
	return(-1);
}

