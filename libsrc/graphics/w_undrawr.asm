;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_undrawr.asm,v 1.3 2015-01-19 01:32:46 pauloscustodio Exp $
;


                PUBLIC    undrawr
                EXTERN     swapgfxbk
                EXTERN	swapgfxbk1

                EXTERN     w_line_r
                EXTERN     w_respixel


.undrawr
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

