/*
 *      Part of the library for fcntlt
 *
 *      int open(char *name,int access, mode_t mode)
 *
 *      djm 3/10/2002
 *
 *      Flags is one of: O_RDONLY, O_WRONLY, O_RDWR
 *      Or'd with any of: O_CREAT, O_TRUNC, O_APPEND
 *
 *      All others are ignored(!)
 *
 * -----
 * $Id: open.c,v 1.1 2002-10-03 20:07:20 dom Exp $
 */


#include <fcntl.h>      /* Or is it unistd.h, who knows! */

int open(far char *name, int flags, mode_t mode)
{
	char	buffer[10];	/* Buffer for expansion */

	return (open_z88(name,flags,mode,buffer,9));
}

