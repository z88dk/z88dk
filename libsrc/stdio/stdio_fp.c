/*
 *	This is the table of entries for stdio
 *
 *	Not actually a library routine - placed in
 *	{z88dk}/lib/stdio_fp.asm and included by the _crt0
 *	code as required
 */

#define ANSI_STDIO

#include <stdio.h>


struct filestr _sgioblk[FOPEN_MAX]= {
	{ 0 , _IOSYSTEM | _IOREAD  | _IOUSE , 0 },
	{ 0 , _IOSYSTEM | _IOWRITE | _IOUSE , 0 },
	{ 0 , _IOSYSTEM | _IOWRITE | _IOUSE , 0 },
	{ 0 , 0 , 0 },
	{ 0 , 0 , 0 },
	{ 0 , 0 , 0 },
	{ 0 , 0 , 0 },
	{ 0 , 0 , 0 },
	{ 0 , 0 , 0 },
	{ 0 , 0 , 0 }
};

