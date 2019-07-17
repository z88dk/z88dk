
#define ANSI_STDIO

#include <stdio.h>



int sprintf(char *str,char *fmt,...)
{
#asm
        EXTERN  vfprintf
        EXTERN  __sgoioblk
        ld      l,a
        ld      h,0
        add     hl,hl
        add     hl,sp	;points to buf
	ex	de,hl	;de=&buf
	ld	hl,-10	;make space for fp
	add	hl,sp	
	ld	sp,hl
	push	hl	;push fp
	ld	a,(de)
	ld	(hl),a
	inc	de
	inc	hl
	ld	a,(de)
	ld	(hl),a
	inc	hl
	ld	(hl),_IOWRITE|_IOSTRING;
	inc	hl
	ld	(hl),0
	ex	de,hl	;hl=&ptr + 1
	dec	hl	
	dec	hl	;&ptr
	ld	d,(hl)	;&fmt
	dec	hl
	ld	e,(hl)
	push	de
	dec	hl
	dec	hl
	push	hl	;ap
        call    vfprintf
	pop	bc
	pop	bc
	pop	bc
	ex	de,hl
	ld	hl,0
	add	hl,sp	;hl=&file
	ld	c,(hl)	;ptr
	inc	hl
	ld	b,(hl)
	xor	a
	ld	(bc),a	;terminate string
	ld	hl,10
	add	hl,sp
	ld	sp,hl
#endasm
}
