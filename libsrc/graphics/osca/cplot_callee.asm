;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Color HRG version by Stefano Bodrato
;
;	$Id: cplot_callee.asm $
;

;Usage: cplot_callee(int x, int y, int color)


                SECTION   code_clib
                PUBLIC    cplot_callee
                PUBLIC    _cplot_callee
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     cplotpixel

.cplot_callee
._cplot_callee
		pop	af
		pop	bc
		pop	de
		pop	hl
		push  af
		ld	a,c
		ex af,af

                call    swapgfxbk
                call    cplotpixel
                jp      swapgfxbk1

