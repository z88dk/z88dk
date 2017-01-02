;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_unplot.asm,v 1.4 2017-01-02 21:51:24 aralbrec Exp $
;

;Usage: unplot(int x, int y)


	SECTION   code_clib
                PUBLIC    unplot
                PUBLIC    _unplot
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     w_respixel

.unplot
._unplot
		pop	bc
		pop	de
		pop	hl
		push	hl
		push	de
		push	bc

                call    swapgfxbk
                call    w_respixel
                jp      swapgfxbk1

