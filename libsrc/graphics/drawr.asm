;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;
;	$Id: drawr.asm,v 1.6 2015-01-19 01:32:46 pauloscustodio Exp $
;


;Usage: drawr(struct *pixels)


                PUBLIC    drawr
                EXTERN     swapgfxbk
                EXTERN	swapgfxbk1

                EXTERN     Line_r
                EXTERN     plotpixel



.drawr
		ld	ix,0
		add	ix,sp
		ld	e,(ix+2)	;py
		ld	d,(ix+3)
		ld	l,(ix+4)	;px
		ld	h,(ix+5)

                call    swapgfxbk
                ld      ix,plotpixel
                call    Line_r
                jp      swapgfxbk1

