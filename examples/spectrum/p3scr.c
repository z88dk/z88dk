/*
   Simple program for the ZX Spectrum +3 CP/M
   loads a .SCR picture on the D-FILE leaving
   the rightmost pixel clean (it wouldn't be
   updated by the console output driver).
*/

/* To build:
		zcc +cpm  +cpm -startup=3 -p3scr.com p3scr.c
*/


#include <stdio.h>
#include <stdlib.h>

int c,i;
FILE	*fp;

int p3_poke(addr,val) {
#asm
	extern p3_poke

    pop af
	pop de
	pop hl
	push hl
	push de
	push af
	ld a,e
    call p3_poke
#endasm
}


int main(int argc, char *argv[])
{
	for (i=0;i<22;i++)
		fputc_cons('\n');

	if ((fp = fopen(argv[1],"rb")) != NULL) {
		for (i=0;i<6144;i++) {
			c=getc(fp);
			if ((i % 32) == 31) c=c&0xFE;
			p3_poke(16384+i,c);
		}
		for (i=6144;i<6912;i++) {
			p3_poke(16384+i,getc(fp));
		}
	fclose(fp);
	}
}

