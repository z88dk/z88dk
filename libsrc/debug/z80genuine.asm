; *
; *	General Z80 debugging functions
; *
; *	Stefano 25/6/2009
; *
; *	TRUE if Z80 undocumented flags behave like the real Z80.
; *	extern int  __LIB__ z80undoc(void);
; *
; *	$Id: z80genuine.asm,v 1.3 2016-03-06 21:45:13 dom Exp $
; *

	SECTION	code_clib
	PUBLIC	z80genuine
	PUBLIC	_z80genuine

z80genuine:
_z80genuine:
	ld	h,@00001000	; test bit 3
	call	test
	cp	@00001000
	ret	nz
	
	ld	h,@00100000	; test bit 5
	call	test
	cp	@00100000
	ret	nz
	
	inc	hl
	ret

test:
	add	hl,de
	bit	0,(hl)
	push	af
	pop	bc
	ld	a,c
	ld	hl,0
	and	@00101000
	ret
