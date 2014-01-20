/*
;	S-OS specific routines
;	by Stefano Bodrato, 2013
;
;       $Id: rnd_saveblock.c,v 1.1 2014-01-20 09:15:31 stefano Exp $
;
*/

#define __HAVESEED
#include <stdlib.h>
#include <fcntl.h>
#include <spectrum.h>



int rnd_saveblock(char *name,unsigned int pos, unsigned int len) {

/*
7650 - SAVE block
a=addess
l=length
d=drive number
n$=file name
*/

	zxgetfname2(name);

	zx_setint("A",pos);
	zx_setint("L",len);

	if (zx_goto(7650)==9)
		return (0);
	else
		return(-1);

}
