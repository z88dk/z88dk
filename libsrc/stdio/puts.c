/*
 *	Generic stdio library
 *
 *	puts(blah) - print blah to stdout with trailing LF
 *
 *	djm 2/4/2000
 */

#define ANSI_STDIO
#include <stdio.h>

int puts(char *s)
{
	fputs(s,stdout);
	fputc('\n',stdout);
}

