;
;       Z88DK Graphics Functions - Small C+ stubs
;
;       Fill stub - Stefano Bodrato 11/6/2000
;
;


;Usage: fill(struct *pixel)


                XLIB    fill

                LIB     do_fill
                LIB     swapgfxbk
		XREF	swapgfxbk1

.fill
		ld	ix,0
		add	ix,sp
		ld	d,(ix+2)	;y
		ld	e,(ix+4)	;x
                call    swapgfxbk
                call    do_fill
                jp      swapgfxbk1

