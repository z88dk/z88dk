/*
 *	long fdtell(int handle);
 *
 *	Stefano Bodrato - Feb. 2005
 *
 *	$Id: fdtell.c,v 1.1 2012-03-08 07:16:46 stefano Exp $
*/

#include <fcntl.h>
#include <zxinterface1.h>


long fdtell(int handle)
{
	struct M_CHAN *if1_file;
	if1_file = (char *) handle;
	return (if1_file->position);
}
