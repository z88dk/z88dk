;
;	Generic game device library
;	Stefano Bodrato - 20/8/2001
;
;	$Id: joystick.asm,v 1.5 2016-04-23 21:06:32 dom Exp $
;

	SECTION   code_clib
        PUBLIC    joystick
        PUBLIC    _joystick
	EXTERN	getk

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	a,l

	cp	1	 ; Stick emulation 1 (qaop-mn)
	jr	nz,j_no1
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
.j_no1
	cp	2	 ; Stick emulation 2 (8246-05)
	jr	nz,j_no2
	call	getk
	ld	a,l
	ld	l,0
	cp	'0'
	jr	nz,no_fire1_a
	set	4,l
	jr	j_done
.no_fire1_a
	cp	'5'
	jr	nz,no_fire2_a
	set	5,l
	jr	j_done
.no_fire2_a
	cp	'8'
	jr	nz,no_up_a
	set	3,l
	jr	j_done
.no_up_a
	cp	'2'
	jr	nz,no_down_a
	set	2,l
	jr	j_done
.no_down_a
	cp	'4'
	jr	nz,no_left_a
	set	1,l
	jr	j_done
.no_left_a
	cp	'6'
	jr	nz,no_right_a
	set	0,l
.no_right_a
	jr	j_done
.j_no2
	xor	a
.j_done
	ret
