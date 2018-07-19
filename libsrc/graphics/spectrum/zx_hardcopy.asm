;
;		Copy the graphics area to the zx printer
;
;		Stefano Bodrato, 2018
;
;
;	$Id: zx_hardcopy.asm $
;
		SECTION code_clib
		PUBLIC    zx_hardcopy
		PUBLIC    _zx_hardcopy
		

.zx_hardcopy
._zx_hardcopy
		ld	hl, $0A02
		ld	a,(hl)
		cp	$f3		; DI instruction, should be in that position only for the TS2068
		jr	nz,no_ts2068
		jp	(hl)
.no_ts2068
		jp	$0EAC
