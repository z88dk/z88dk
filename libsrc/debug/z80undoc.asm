; *
; *	General Z80 debugging functions
; *
; *	Stefano 23/6/2009
; *
; *	TRUE if Z80 supports undocumented instructions.
; *	extern int  __LIB__ z80undoc(void);
; *
; *	$Id: z80undoc.asm,v 1.2 2015-01-19 01:32:42 pauloscustodio Exp $
; *

	PUBLIC	z80undoc


z80undoc:
	;xor	a
	;ld	h,a
	;push	hl	; protect stack in case we have a Rabbit
	;defb	$ed
	;defb	$54	; ex (sp),hl ONLY IF we're on a Rabbic Control Module
	;		; NEG if genuine Z80
	;nop	; this could help z80 clones not to hurt too much
	;nop
	;pop	hl
	;jr	nz,notgenuine
	
	xor	a
	ld	h,a
	ld	ix,$0101

	;defb	0fdh		;
	defb	0ddh		; ld a,xh
	ld	a,h

	nop	; this could help z80 clones not to hurt too much
	nop
	
	ld	l,a	; true (1)
	ld	h,0
	dec	a
	ret	z

notgenuine:
	ld	l,h	; false (0)
	ret
