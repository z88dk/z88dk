
#define ANSI_STDIO

#include <stdio.h>


/*
 * Cheating somewhat, this will cause a barf in the compiler...bigtime..
 * nevermind...
 */


int fprintf(FILE *fp, char *fmt,...)
{
#asm
        EXTERN  vfprintf
        EXTERN  __sgoioblk
        ld      l,a
        ld      h,0
        add     hl,hl
        add     hl,sp	;points to fp

	ld	c,(hl)
	inc	hl
	ld	b,(hl)
	dec	hl
	dec	hl
        push    bc
        ld      d,(hl)  ;fmt
        dec	hl
        ld      e,(hl)
	push	de
        dec     hl
        dec     hl	;points to ap
        push    hl
        call    vfprintf
        pop     bc
        pop     bc
        pop     bc
#endasm
}
