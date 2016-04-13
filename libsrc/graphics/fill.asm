;
;       Z88DK Graphics Functions - Small C+ stubs
;
;       Fill stub - Stefano Bodrato 11/6/2000
;
;
;	$Id: fill.asm,v 1.5 2016-04-13 21:09:09 dom Exp $
;


;Usage: fill(struct *pixel)


                SECTION         code_clib
                PUBLIC    fill
                PUBLIC    _fill

                EXTERN     do_fill
                EXTERN     swapgfxbk
		EXTERN	   __graphics_end

.fill
._fill
		push	ix
		ld	ix,2
		add	ix,sp
		ld	d,(ix+2)	;y
		ld	e,(ix+4)	;x
                call    swapgfxbk
                call    do_fill
                jp      __graphics_end

