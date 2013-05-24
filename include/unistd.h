/*
 *  Just a placeholder
 *
 *	$Id: unistd.h,v 1.2 2013-05-24 06:57:10 stefano Exp $
 */

#ifndef __UNISTD_H__
#define __UNISTD_H__

#include <sys/compiler.h>
#include <sys/types.h>

extern char *environ[];
#define isatty(fd) fchkstd(fd)

#endif
