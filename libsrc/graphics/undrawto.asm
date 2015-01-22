;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: undrawto.asm,v 1.5 2015-01-22 17:23:48 stefano Exp $
;


;Usage: undrawto(struct *pixels)


                PUBLIC    undrawto
                EXTERN     swapgfxbk
                EXTERN	swapgfxbk1

				EXTERN	coords

                EXTERN     Line
                EXTERN     respixel



.undrawto
		ld	ix,0
		add	ix,sp
		ld	hl,(coords)
		ld	e,(ix+2)	;y
		ld	d,(ix+4)	;x

                call    swapgfxbk
                ld      ix,respixel
                call    Line
                jp      swapgfxbk1

