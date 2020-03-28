;
;	Game device library for the TI calculators
;	Stefano Bodrato - 21/8/2001
;	Henk Poley	- 03/9/2001
;
;	$Id: joystick.asm,v 1.7 2016-06-16 20:23:52 dom Exp $
;

	SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	c,l

	ld	hl,-1		; HL = 'ERROR'
	dec	c		; Test if device 1 is requested
	jr	z,device1	;
.error
	ret

.device1			; H = -1
	inc	l		; L =  0
	inc	c		; C =  1
	out	(c),h		; Reset keypad (out (1),$FF)
	ld	a,$BF		; Enable group 7
	out	(1),a		;
	in	a,(1)		;
	and	@00100000	; [2nd] pressed ?
	jr	nz,nofire1	; if zero, then [2nd] was pressed
	inc	l		; L = @00000001
.nofire1
	;out	(c),h		;
	ld	a,$DF		; Enable group 6
	out	(1),a		;
	in	a,(1)		;
	and	@10000000	; [Alpha] pressed ?
	jr	nz,nofire2	; if zero, then [Alpha]
	set	1,l		; L = @0000001x
.nofire2
	out	(c),h		;
	ld	a,$FE		; Enable group 1
	out	(1),a		;
	in	a,(1)		;
	cpl			;

	rl	l		; space for the [up] bit
	rra			; [down] bit  -> Carry
	rl	l		; L <- Carry
	rra			; [left] bit  -> Carry
	rl	l		; L <- Carry
	rra			; [right] bit -> Carry
	rl	l		; L <- Carry
	rra			; [up] bit    -> Carry

	jr	nc,j_done	; Test Carry, if set...
	set	3,l		; then, set bit 3 in L
.j_done				; else, return
	inc	h		; H = 0
	ret
