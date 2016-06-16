;
;	Game device library for the ZX Spectrum
;	Stefano Bodrato - 20/8/2001
;
;	$Id: joystick.asm,v 1.5 2016-06-16 20:23:52 dom Exp $
;

	INCLUDE	"zxvgs.def"

        SECTION code_clib
        PUBLIC  joystick
        PUBLIC  _joystick

.joystick
._joystick
	;__FASTALL__ : joystick no. in HL
		
	ld	a,l

	cp	1	 ; Joystick 0
	jr	nz,j_no1
	rst	8
	defb	ZXVGS_J0
	jp	j_done
.j_no1
	cp	2	 ; Joystick 1
	jr	nz,j_no2
	rst	8
	defb	ZXVGS_J1
	jr	j_done
.j_no2
	cp	3	 ; Joystick 2
	jr	nz,j_no3
	rst	8
	defb	ZXVGS_J2
	jr	j_done
.j_no3
	cp	4	 ; Joystick 3
	jr	nz,j_no4
	rst	8
	defb	ZXVGS_J3
.j_no4
	xor	a
.j_done
	ld	h,0
	ld	l,a
	ret
