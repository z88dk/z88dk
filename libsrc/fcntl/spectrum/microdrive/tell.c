/*
 *	long tell(int handle);
 *
 *	Stefano Bodrato - Feb. 2005
 *
 *	$Id: tell.c,v 1.1 2005-02-18 08:35:53 stefano Exp $
*/

#include <fcntl.h>
#include <zxinterface1.h>


long tell(int handle)
{
	struct M_CHAN *if1_file;
	if1_file = (char *) handle;
	return (if1_file->position);
}
