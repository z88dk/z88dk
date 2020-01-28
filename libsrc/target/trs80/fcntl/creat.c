/*
 *  FCNTL library for the TRS-80
 *  Create a file
 *
 *  $Id: creat.c $
 */


#include <fcntl.h>


int creat(char *name, mode_t mode)
{
	return open(name, O_WRONLY, mode);

}
