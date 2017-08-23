/*  OSCA FLOS fcntl lib
 *
 * 	create directory
 *
 *	Stefano Bodrato - Oct 2012
 *
 *	$Id: mkdir.c,v 1.1 2012-10-15 11:58:09 stefano Exp $
 */

//#include <stdio.h>
#include <sys/stat.h>
#include <flos.h>


extern int __FASTCALL__ mkdir(char *dirname)
{
	if (make_dir(dirname) == 0) return 0;
    return (-1);
}
