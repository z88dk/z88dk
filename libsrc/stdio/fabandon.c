/*
 *	Abandon file
 *
 *	fabandon(FILE *fp)
 *
 *	djm 1/4/2000
 *
 *	If implemented this routine should obviously check that
 *	it's alright to close a file (i.e. not string or default
 *	std*)
 */


#define ANSI_STDIO
#ifdef Z80
#define STDIO_ASM
#endif
#include <stdio.h>

void fabandon(FILE *fp)
{
/* Z88 has no abandon file command, just reset fp */
#ifdef Z80
#asm
	pop	de
	pop	ix
	push	ix
	push	de
	xor	a
	ld	(ix+fp_desc),a
	ld	(ix+fp_desc+1),a
	ld	(ix+fp_ungetc),a
	ld	(ix+fp_flags),a
#endasm
#else
	fp->desc.fd=0;
	fp->flags=0;
	fp->ungetc=0;
#endif
}

