;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Color HRG version by Stefano Bodrato
;
;	$Id: cplot.asm,v 1.4 2017-01-02 22:57:58 aralbrec Exp $
;

;Usage: cplot(int x, int y, int color)


                SECTION   code_clib
                PUBLIC    cplot
                PUBLIC    _cplot
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     cplotpixel

.cplot
._cplot
		pop	af
		pop	bc
		pop	de
		pop	hl
		push  hl
		push  de
		push  bc
		push  af
		ld	a,c
		ex af,af

                call    swapgfxbk
                call    cplotpixel
                jp      swapgfxbk1

