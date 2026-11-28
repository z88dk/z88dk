//  example by Stefano Bodrato
//  z88dk-z80asm.exe z88dka.asm z88dkb.asm
//  zcc +cpm -lndos -create-app z88dkm.c z88dka.o z88dkb.o

#include <stdio.h>
#include <stdlib.h>

extern void putch();
extern void PUBFN();

void putch (int c) {
	fputc_cons (c);
}

void main () {
	PUBFN();
}

