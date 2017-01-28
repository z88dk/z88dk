/*
 *	Generic stdio library
 *
 *	puts(blah) - print blah to stdout with trailing LF
 *
 *	djm 2/4/2000
 *
 * --------
 * $Id: puts.c,v 1.4 2016-04-01 10:39:41 dom Exp $
 */

#define ANSI_STDIO
#include <stdio.h>

int puts(const char *s)
{
	fputs(s,stdout);
	fputs("\n",stdout);
}

