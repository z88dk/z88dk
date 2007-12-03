;
;	Game device library for the MSX
;       Stefano Bodrato - 3/12/2007
;
;	$Id: joystick.asm,v 1.1 2007-12-03 16:05:19 stefano Exp $
;

        XLIB    joystick
        LIB	msxbios
        LIB	getk

.joystick
	pop	hl
	pop	de
	push	de
	push	hl
	
	ld	a,e
	dec	a
	jr	nz,nokeystick
	
	call	getk
	ld	a,l
	ld	l,0
	or	@00100000	; TO_LOWER
	cp	'm'
	jr	nz,no_fire1
	set	4,l
	jr	j_done
.no_fire1
	cp	'n'
	jr	nz,no_fire2
	set	5,l
	jr	j_done
.no_fire2
	cp	'q'
	jr	nz,no_up
	set	3,l
	jr	j_done
.no_up
	cp	'a'
	jr	nz,no_down
	set	2,l
	jr	j_done
.no_down
	cp	'o'
	jr	nz,no_left
	set	1,l
	jr	j_done
.no_left
	cp	'p'
	jr	nz,no_right
	set	0,l
.no_right
.j_done
	ret

.nokeystick
	dec	a
	jr	nz,nostck1

	ld	a,$df	; 11011111
	ld	(loc1+1),a
	ld	a,$4c	; 01001100
	ld	(loc2+1),a
	jr	joyst
.nostck1
	ld	a,$af	; 10101111
	ld	(loc1+1),a
	ld	a,$03	; 00000011
	ld	(loc2+1),a
.joyst
	di
	ld	a,$0f
	out	($0a),a
	in	a,($a2)
.loc1	and	$df
.loc2	or	$4c
	out	($a1),a
	ld	a,$0e
	out	($a0),a
	in	a,($a2)
	ei

; Bit #:  76  5    4   3210
;         ||  |    |   ||||
; Name:   10 TRG2 TRG1 RLDU

	ld	l,0
	ld	h,l
	rra		; UP
	rl	l
	rra		; DOWN
	rl	l	; L
	rra
	rl	l
	rra
	rl	l
	rra
	rl	l
	rra
	rl	l
	ret
