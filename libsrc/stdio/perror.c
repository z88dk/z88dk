/*
 *	Generic stdio library
 *
 *	perror(blah) - print blah to stderr with trailing :<error case>LF
 *
 *	Stefano 2019
 *
 * --------
 * $Id: perror.c $
 */

#define ANSI_STDIO
#include <stdio.h>

void perror(const char *s)
{
	fputs(s,stderr);
	fputs(": error.\n",stderr);
}

