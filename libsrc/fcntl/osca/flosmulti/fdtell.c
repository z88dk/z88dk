/*  OSCA FLOS fcntl lib
 *
 *	long fdtell(int handle);
 *
 *	Stefano Bodrato - Feb. 2005
 *
 *	$Id: fdtell.c,v 1.1 2012-03-21 10:20:23 stefano Exp $
*/

#include <stdio.h>
#include <flos.h>


long fdtell(int myfile)
{
	struct flos_file *flosfile;

	flosfile = (char *) myfile;

	return ((flosfile)->position);
}
