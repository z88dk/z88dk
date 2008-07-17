;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_undrawr.asm,v 1.1 2008-07-17 15:39:56 stefano Exp $
;


                XLIB    drawr
                LIB     swapgfxbk
                XREF	swapgfxbk1

                LIB     w_line_r
                LIB     w_respixel


.drawr
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)
		ld	d,(ix+3)
		ld	l,(ix+4)
		ld	h,(ix+5)
                call    swapgfxbk
                ld      ix,w_respixel
                call    w_line_r
                jp      swapgfxbk1

