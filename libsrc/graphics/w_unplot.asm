;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_unplot.asm,v 1.3 2016-04-23 20:37:40 dom Exp $
;

;Usage: unplot(int x, int y)


	SECTION   code_clib
                PUBLIC    unplot
                EXTERN     swapgfxbk
                EXTERN    swapgfxbk1

                EXTERN     w_respixel

.unplot
		pop	bc
		pop	de
		pop	hl
		push	hl
		push	de
		push	bc

                call    swapgfxbk
                call    w_respixel
                jp      swapgfxbk1

