;
;       Z88DK Graphics Functions - Small C+ stubs
;
;       Fill stub - Stefano Bodrato 11/6/2000
;
;
;	$Id: fill.asm,v 1.4 2016-04-13 20:16:59 dom Exp $
;


;Usage: fill(struct *pixel)


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

