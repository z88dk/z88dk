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
 *
 * --------
 * $Id: fabandon.c,v 1.1 2002-05-10 11:08:56 dom Exp $
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
	pop	hl
	push	hl
	push	de
	xor	a
	ld	(hl),a	;fp_desc
	inc	hl
	ld	(hl),a	;fp_desc+1
	inc	hl
	ld	(hl),a	;fp_ungetc
	inc	hl
	ld	(hl),a	;fp_flags
#endasm
#else
	fp->desc.fd=0;
	fp->flags=0;
	fp->ungetc=0;
#endif
}

