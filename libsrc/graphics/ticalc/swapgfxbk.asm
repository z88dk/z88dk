;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;	TI calcs: Copy GRAPH MEM to LCD when finished.
;	By Stefano Bodrato - Dec. 2000
;
;
;	$Id: swapgfxbk.asm,v 1.6 2001-04-18 13:21:38 stefano Exp $
;


                XLIB    swapgfxbk
		XDEF	swapgfxbk1

		XREF	cpygraph


.swapgfxbk
		ret

.swapgfxbk1
		push	hl
		push	de
		push	bc

		call	cpygraph	; Copy GRAPH_MEM to LCD, then return

		pop	bc
		pop	de
		pop	hl

		ret
