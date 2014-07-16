;
;	Generic game device library - VG-5000 port
;	Stefano Bodrato - 2014
;
;	$Id: joystick.asm,v 1.1 2014-07-16 09:59:57 stefano Exp $
;


	XLIB    joystick
	LIB	getk

.joystick
	;__FASTALL__ : joystick no. in HL
		
	;ld	a,l

	call	getk
	ld	a,l
	ld	l,0
	cp	' '
	jr	nz,no_fire1_a
	set	4,l
	jr	j_done
.no_fire1_a
	cp	'1'
	jr	nz,no_fire2_a
	set	5,l
	jr	j_done
.no_fire2_a
	cp	9
	jr	nz,no_up_a
	set	3,l
	jr	j_done
.no_up_a
	cp	10
	jr	nz,no_down_a
	set	2,l
	jr	j_done
.no_down_a
	cp	8
	jr	nz,no_left_a
	set	1,l
	jr	j_done
.no_left_a
	cp	7
	jr	nz,no_right_a
	set	0,l
.no_right_a

.j_done

	ret

	