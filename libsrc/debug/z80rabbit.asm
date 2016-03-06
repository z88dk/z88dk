; *
; *	General Z80 debugging functions
; *
; *	Stefano 25/6/2009
; *
; *	TRUE if we're running on a rabbit.
; *	extern int  __LIB__ z80rabbit(void);
; *
; *	$Id: z80rabbit.asm,v 1.3 2016-03-06 21:45:13 dom Exp $
; *

	SECTION	code_clib
	PUBLIC	z80rabbit
	PUBLIC	_z80rabbit

z80rabbit:
_z80rabbit:
	ld	hl,0
	ld	de,1
	push	de
	defb	$ed
	defb	$54	; ex (sp),hl ONLY IF we're on a Rabbic Control Module
	nop	; this could help z80 clones not to hurt too much
	nop
	pop	de
	ret
