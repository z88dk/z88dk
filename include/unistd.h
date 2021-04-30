/*
 *	$Id: unistd.h $
 */

#ifndef __UNISTD_H__
#define __UNISTD_H__

#include <sys/compiler.h>
#include <sys/types.h>

extern char *environ[];
#define isatty(fd) fchkstd(fd)
#define unlink(a) remove(a)


/* Archaic version of execl(), used in the earlier C implementations */
/* At the moment only CP/M is supported with a single "argument", the original fn name was exec() */
extern int __LIB__ execl (const char *command, const char *args) __smallc;

/* (Work in progress): Execute a command passing the argument structure */
extern int __LIB__ execv (const char *command, const char *args[]) __smallc;



#endif
