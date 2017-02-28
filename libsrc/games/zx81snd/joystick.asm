;
;	ZX81 game device library
;	Stefano Bodrato - Dec. 2014
;
;	$Id: joystick.asm,v 1.6 Stefano Exp, Feb 2017 $
;

    SECTION code_clib
    PUBLIC   joystick
    PUBLIC   _joystick
    EXTERN    restore81

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	a,l

	cp	1	 ; Kempston Joystick
	jr	nz,j_no1
	in	a,(31)
	ld	l,a
	jp	j_done
.j_no1

	cp	2	 ; ZXpand
	jr	nz,j_no2
	; Read the joystick.
	ld bc,$e007 ;1110000000000111
	ld a,$a0
	out (c),a
	nop
	nop
	nop   ; [some small delay, 10 clocks or so]
	in a,(c)
	ld e,a
	rra
	rra
	rra
	and 15
	ld d,a
	ld a,e
	rla
	rla
	and 16
	or d
	; bit 1 -> right
	; bit 2 -> left
	; bit 3 -> down
	; bit 4 -> up
	ld	l,a
	jr	j_done
.j_no2

	cp	3	 ; Stick emulation 3 (qaop-mn)
	jr	nz,j_no3

	call	restore81
	call	699
	
	ld  d,0
	bit	7,l
	jr  nz,nofire
	ld	a,h		; n,m
	xor	255
	rla
	and @00110000
	ld	d,a
.nofire
; q = 11111101 11111011
; a = 11111011 11111101
	ld	a,l
	rla
	
	and 12	;@00001100
	xor 12
	cp  12
	jr	z,doop
	or	d
	ld	d,a
.doop
	bit	5,l		; o,p
	ld	a,d
	jr	nz,qaop_end
	ld	a,h
	rra
	and 3
	xor 3
	or	d
.qaop_end
	ld	l,a
	jr	j_done
.j_no3

	cp	4	 ; Stick emulation 4 (Cursor Keys)
	jr	nz,j_no4
	call	restore81
	call	699
	
	ld  e,0
	bit	3,l
	jr  nz,no5
	bit	5,h
	jr  nz,no5
	set	1,e
.no5
	bit	4,l
	ld	l,e
	jr	nz,j_done

	bit	1,h
	jr	nz,no0
	set	4,l
.no0
	bit	2,h
	jr	nz,no9
	set	5,l
.no9
	bit	5,h
	jr	nz,no6
	set	2,l
.no6
	bit	4,h
	jr	nz,no7
	set	3,l
.no7
	bit	3,h
	jr	nz,no8
	set	0,l
.no8
	jr	j_done
.j_no4

	xor	a
.j_done
	ld	h,0
	ret
