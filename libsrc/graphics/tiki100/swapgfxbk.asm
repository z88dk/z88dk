;
;       Z88 Graphics Functions - Small C+ stubs
;
;       Written around the Interlogic Standard Library
;
;       Stubs Written by D Morris - 15/10/98
;
;
;       Page the graphics bank in/out - used by all gfx functions
;       Simply does a swap...
;
;
;	$Id: swapgfxbk.asm,v 1.2 2017-01-02 22:57:59 aralbrec Exp $
;

		PUBLIC    swapgfxbk
      PUBLIC    _swapgfxbk

		PUBLIC    swapgfxbk1
      PUBLIC    _swapgfxbk1



.swapgfxbk
._swapgfxbk
	DI
	EX AF,AF
	LD A,($FFC8)	; Copy of system register
	OR $08			; select graphics RAM bank
	OUT ($1C),A		; System register (page-in gfx RAM)
	EX AF,AF
	RET

.swapgfxbk1
._swapgfxbk1
	EX AF,AF
	LD A,($FFC8)	; Copy of system register
	OUT ($1C),A		; System register (page-out gfx RAM)
	EX AF,AF
	EI
	RET






