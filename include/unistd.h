/*
 *  Just a placeholder
 *
 *	$Id: unistd.h,v 1.3 2013-06-26 13:34:42 stefano Exp $
 */

#ifndef __UNISTD_H__
#define __UNISTD_H__

#include <sys/compiler.h>
#include <sys/types.h>

extern char *environ[];
#define isatty(fd) fchkstd(fd)
#define unlink(a) remove(a)


#endif
