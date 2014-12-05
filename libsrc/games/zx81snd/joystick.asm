;
;	ZX81 game device library
;	Stefano Bodrato - Dec. 2014
;
;	$Id: joystick.asm,v 1.1 2014-12-05 19:18:41 stefano Exp $
;


    XLIB   joystick
    LIB    getk

.joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	a,l

	cp	1	 ; Kempston Joystick
	jr	nz,j_no1
	in	a,(31)
	jp	j_done
.j_no1

	cp	2	 ; ZXpand
	jr	nz,j_no2
	; Read the joystick.
	ld bc,$e007 ;1110000000000111
	ld a, $a0
	out (c), a
	nop
	nop
	nop   ; [some small delay, 10 clocks or so]
	in a, (c)
	
	rra
	rra
	rra
	; bit 1 -> right
	; bit 2 -> left
	; bit 3 -> down
	; bit 4 -> up
	jp	j_done

.j_no2

	cp	3	 ; Stick emulation 3 (qaop-mn)
	jr	nz,j_no3
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
	jr	j_done
.j_no3

	cp	4	 ; Stick emulation 4 (Cursor Keys)
	jr	nz,j_no4
	call	getk
	ld	a,l
	ld	l,0
	cp	'0'
	jr	nz,no_fire1_a
	set	4,l
	jr	j_done
.no_fire1_a
	cp	'9'
	jr	nz,no_fire2_a
	set	5,l
	jr	j_done
.no_fire2_a
	cp	'6'
	jr	nz,no_up_a
	set	3,l
	jr	j_done
.no_up_a
	cp	'7'
	jr	nz,no_down_a
	set	2,l
	jr	j_done
.no_down_a
	cp	'5'
	jr	nz,no_left_a
	set	1,l
	jr	j_done
.no_left_a
	cp	'8'
	jr	nz,no_right_a
	set	0,l
.no_right_a
	jr	j_done
.j_no4

	xor	a
.j_done
	ret
