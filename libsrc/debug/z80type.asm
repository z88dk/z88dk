; *
; *	General Z80 debugging functions
; *
; *	Stefano 3/7/2009
; *
; *	extern int  __LIB__ z80type(void);
; *	
; *	0 - Z80
; *	1 - Z180 / HD6140
; *	2 - Z280
; *	3 - Z380
; *	4 - Z800 / R800 (i.e. MSX TurboR in R800 mode.)
; *	5 - Rabbit Control Module
; *	*** 6 - ? GameBoy ?
; *	*** 7 - ? S1MP3 ?
; *	*** 8 - ? EZ80 ?
; *
; *	$Id: z80type.asm,v 1.3 2016-03-06 21:45:13 dom Exp $
; *

	SECTION	code_clib
	PUBLIC	z80type
	PUBLIC	_z80type


z80type:
_z80type:
	ld	hl,0
	ld	de,1
	push	de
	defb	$ed
	defb	$54	; ex (sp),hl ONLY IF we're on a Rabbic Control Module
	nop	; this could help z80 clones not to hurt too much
	nop
	pop	de
	dec	l
	jr	nz,norabbit
	ld	l,5	; Rabbit
	ret
norabbit:

	xor	a	; $af

	defb	$cb,$37	; on Z80 it acts as "SLL A" (left shift forcing rightmost bit to 1)
			; on Z380 - EX A,A'
			; on Z280 - TSET A

	ld	a,2	; $3e $02

	defb	$cb,$37	
	
	and	a	; happens if we are run by a Z380
	ld	l,3	; Z380
	ret	z
	
	cp	5	; happens if we found a Z80 SLL command
	jr	z,noz280
	
	dec	l	; [2]
	cp	1	; happens if TSET has forced A to 1 (Z280)
	ret	z	; Z280
	dec	l	; else Z180 [1]
	ret
		
noz280:
	ld	l,0
	ld	a,1
	ld	c,4
	defb	$ed	; MULT A,C (result goes in HL) on Z280 or Z800/R800
	defb	$c9
	ret	; [0] or [4]

