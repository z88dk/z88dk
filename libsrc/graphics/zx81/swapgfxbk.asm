;
;       ZX81 Graphics Functions - Small C+ stubs
;
;


                XLIB    swapgfxbk

		XDEF	swapgfxbk1


.phlsave	defw	0

.swapgfxbk
		exx
		ld	(phlsave),hl
		exx
		ret
.swapgfxbk1
		ld	iy,16384
		exx
		ld	hl,(phlsave)
		exx
                ret
