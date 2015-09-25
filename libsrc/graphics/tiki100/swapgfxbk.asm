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
;	$Id: swapgfxbk.asm,v 1.1 2015-09-25 14:56:01 stefano Exp $
;

		PUBLIC    swapgfxbk

		PUBLIC    swapgfxbk1



.swapgfxbk
	DI
	EX AF,AF
	LD A,($FFC8)	; Copy of system register
	OR $08			; select graphics RAM bank
	OUT ($1C),A		; System register (page-in gfx RAM)
	EX AF,AF
	RET

.swapgfxbk1
	EX AF,AF
	LD A,($FFC8)	; Copy of system register
	OUT ($1C),A		; System register (page-out gfx RAM)
	EX AF,AF
	EI
	RET






