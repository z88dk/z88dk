/*
 *	long fdtell(int handle);
 *
 *	Stefano Bodrato - Feb. 2005
 *
 *	$Id: fdtell.c $
*/

#include <fcntl.h>
#include <arch/zx/zxinterface1.h>


long fdtell(int handle)
{
	struct M_CHAN *if1_file;
	if1_file = (void *) handle;
	return (if1_file->position);
}
