/*
 *	long fdtell(int handle);
 *
 *	Stefano Bodrato - 2013
 *
 *	$Id: fdtell.c,v 1.1 2014-01-14 07:48:41 stefano Exp $
*/

#include <fcntl.h>


long fdtell(int handle)
{
	struct RND_FILE *myfile;

	myfile = (char *) handle;
	return (myfile->position);
}
