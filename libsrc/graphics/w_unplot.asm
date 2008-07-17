;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 30/9/98
;
;       Wide resolution (WORD based parameters) version by Stefano Bodrato
;
;	$Id: w_unplot.asm,v 1.1 2008-07-17 15:39:56 stefano Exp $
;

;Usage: unplot(int x, int y)


                XLIB    unplot
                LIB     swapgfxbk
                XREF    swapgfxbk1

                LIB     w_respixel

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

