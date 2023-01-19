/*
 *	Rename a file on Microdrive
 *
 *	Stefano Bodrato - Oct. 2004
 *
 *	$Id: rename.c $
 */

#include <errno.h>

int rename(char *oldname, char *newname)
{
  errno = ENOTSUP;
  return -1;
}
