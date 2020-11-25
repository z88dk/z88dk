/*
 *  int fileno(FILE *fp)
 *
 *  Get a file file descriptor from a file pointer 
 *  Stefano, 25/11/2020
 *
 *  $Id: fileno.c $
 */

#define ANSI_STDIO
#include <stdio.h>

extern int __LIB__	fileno(FILE *fp) __z88dk_fastcall
{
	return (fp->desc.fd);
}
