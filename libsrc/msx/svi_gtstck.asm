;
;	Spectravideo SVI specific routines
;	by Stefano Bodrato
;	MSX emulation layer
;
;	GTSTCK
;
;
;	$Id: svi_gtstck.asm,v 1.1 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	GTSTCK
	
	LIB	svi_kbdstick
	LIB	svi_slstick


IF FORmsx
        INCLUDE "#msx.def"
ELSE
        INCLUDE "#svi.def"
ENDIF



GTSTCK:
	dec	a
	jp	m,getkeys

	call	svi_slstick

	ld	hl,$3253	; Joystick table
stick1:	and	$0f
	ld	e,a
	ld	d,0
	add	hl,de
	ld	a,(hl)
	ret

getkeys:
	call	svi_kbdstick
	rrca
	rrca
	rrca
	rrca
	ld	hl,keystick_tb	; KeyboardStick table
	jr	stick1

keystick_tb:
	defb	0,3,5,4,1,2,0,3,7,0,6,5,8,1,7,0
