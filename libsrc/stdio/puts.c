/*
 *	Generic stdio library
 *
 *	puts(blah) - print blah to stdout with trailing LF
 *
 *	djm 2/4/2000
 *
 * --------
 * $Id: puts.c,v 1.2 2001-04-13 14:13:58 stefano Exp $
 */

#define ANSI_STDIO
#include <stdio.h>

int puts(char *s)
{
	fputs(s,stdout);
	fputc('\n',stdout);
}

