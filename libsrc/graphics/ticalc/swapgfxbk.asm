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
;	Feb. 2000 - various fixes (di/ei and dcircle2.asm workaround)
;


                XLIB    swapgfxbk
		XDEF	swapgfxbk1

		XREF	cpygraph


.bc1save	defw	0

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
