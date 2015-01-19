;
;       Z88DK Graphics Functions - Small C+ stubs
;
;       Fill stub - Stefano Bodrato 11/6/2000
;
;
;	$Id: fill.asm,v 1.3 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: fill(struct *pixel)


                PUBLIC    fill

                EXTERN     do_fill
                EXTERN     swapgfxbk
		EXTERN	swapgfxbk1

.fill
		ld	ix,0
		add	ix,sp
		ld	d,(ix+2)	;y
		ld	e,(ix+4)	;x
                call    swapgfxbk
                call    do_fill
                jp      swapgfxbk1

