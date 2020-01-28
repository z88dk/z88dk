;
;	Game device library for the Memotech MTX
;       Stefano Bodrato - 2011
;
;	$Id: joystick.asm,v 1.3 2016-06-16 20:23:51 dom Exp $
;

	SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick



.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
		
	ld	a,l

	ld	hl,0
	dec	a
	jr      nz,no_cursor

	; RIGHT stick
	;xor	a
FIRE:
	ld	a,$df	; Strobe for HOME
	call STROBE
	jr	nz,LEFT
	set	4,l	; FIRE
LEFT:
	ld	a,$f7
	call STROBE
	jr	nz,RIGHT
	set	1,l	; LEFT
RIGHT:
	ld	a,$ef
	call STROBE
	jr	nz,UP
	set	0,l	; RIGHT
UP:
	ld	a,$fb
	call STROBE
	jr	nz,DOWN
	set	3,l	; UP
DOWN:
	ld	a,$bf
	call STROBE
	jr	nz,DONE
	set	2,l	; DOWN
DONE:
	ret


.no_cursor
	xor	a
	ld	a,127	; Strobe for SPACE
	out (5),a
	in	a,(6)
	bit	0,a
	jr	nz,STB
	set	4,l	; FIRE
STB:
	out (5),a
	in	a,(5)
	ld	d,a
	and	$f0
	cp	$f0			; bottom row keys ?
	ret	nz	; no...
	ld	a,d
	cpl
	;DURL	->	UDLR
	ld	e,a
	and @1010
	rra
	ld	d,a
	ld	a,e
	and	@0101
	rla
	or	d
	or	l
	ld	l,a
	ret



STROBE:
	out	(5),a
	in	a,(5)
	cp	127
	ret

	SECTION	bss_clib
KEYS:
	defb	0
