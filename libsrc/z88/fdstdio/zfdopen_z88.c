/*
 *	Open a file (stdio library) returning the explicit
 *	filename
 *
 *	Only hands r,w,a types (no modifiers)
 *
 *	djm 24/3/2000
 */

#define FDSTDIO
#include <stdio.h>
#include <fcntl.h>




FILE *zfdopen_z88(far char *name, char *mode, char *explicit, size_t len)
{
	int	access;
	switch ((unsigned char )*mode) {
		case 'r':
			access=O_RDONLY;
			break;
		case 'w':
			access=O_WRONLY;
			break;
		case 'a':
			access=O_APPEND;
			break;
		default:
			return (FILE *)NULL;
	}
	{
		int fd=open_z88(name,access,0,explicit,len);
		if (fd == - 1 ) return (FILE *)NULL;
		return (FILE *)fd;
	}
}

