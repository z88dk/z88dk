/*
 *      Small C+ Library
 *
 *      More Memory Functions
 *
 *      Added to Small C+ 12/3/99 djm
 *
 *      This one is writ by me!
 *
 *
 *      void *calloc(int num, int size_of_type)
 *
 *      Allocate memory for num*size and clear it (set to 0)
 *
 *
 *	$Id: calloc.c,v 1.4 2002-05-22 20:12:37 dom Exp $
 */

#include <malloc.h>


void *calloc(int num, int size)
{
#if Z80
#asm
	LIB	clrmem

	pop	bc
	pop	hl	;num
	pop	de	;size
	push	de
	push	hl
	push	bc
	call	l_mult
	push	hl	;save total size
	call	malloc	;leave size on stack hl = memory
	pop	bc
	ex	de,hl	;de = memory, bc = size
	push	de	;save it
	call	clrmem
	pop	hl
#endasm
#else
        void *ptr;
        int  tsize;

        tsize=size*num;

        if ( (ptr=malloc(tsize) ) ) {
		memset(ptr,0,tsize);
        }
        return (ptr);
#endif
}


