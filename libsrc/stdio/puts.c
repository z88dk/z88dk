/*
 *	Generic stdio library
 *
 *	puts(blah) - print blah to stdout with trailing LF
 *
 *	djm 2/4/2000
 *
 * --------
 * $Id: puts.c,v 1.3 2016-04-01 10:38:37 dom Exp $
 */

#define ANSI_STDIO
#include <stdio.h>

int puts(char *s)
{
	fputs(s,stdout);
	fputs("\r\n",stdout);
}

