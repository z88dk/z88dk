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

                XLIB    swapgfxbk
		XDEF	swapgfxbk1

		XREF	cpygraph


; WE save all, for now !

.iysave	defw	0
.ixsave	defw	0
.hlsave1 defw	0
.bcsave1	defw	0
.desave1	defw	0
.asave1	defb	0

.swapgfxbk
		di
		ld	(iysave),iy
		ld	(ixsave),ix
		exx
		ld	(hlsave1),hl
		ld	(bcsave1),bc
		ld	(desave1),de
		ld	(asave1),a
		exx

		jp	cpygraph	; Copy GRAPH_MEM to LCD, then return

.swapgfxbk1
		ld	iy,(iysave)
		ld	ix,(ixsave)
		exx
		ld	hl,(hlsave1)
		ld	bc,(bcsave1)
		ld	de,(desave1)
		ld	a,(asave1)
		exx
		ei

		jp	cpygraph	; Copy GRAPH_MEM to LCD, then return
