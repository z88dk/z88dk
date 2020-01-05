/*  OSCA FLOS fcntl lib
 *
 * 	create directory
 *
 *	Stefano Bodrato - Oct 2012
 *
 *	$Id: mkdir.c,v 1.2 2016-07-02 15:41:39 dom Exp $
 */

//#include <stdio.h>
#include <sys/stat.h>
#include <flos.h>

#undef mkdir


int mkdir(char *dirname)
{
	if (make_dir(dirname) == 0) return 0;
    return (-1);
}
