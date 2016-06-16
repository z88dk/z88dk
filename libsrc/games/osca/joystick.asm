;
;	Game device library for the OSCA
;       Stefano Bodrato - 5/9/2011
;
;    --fFUDLR 	Stick bit pattern (nc, nc, fire2, fire1, up, down, left, right)
;
;	$Id: joystick.asm,v 1.3 2016-06-16 20:23:51 dom Exp $
;

	SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick

        INCLUDE "flos.def"
        INCLUDE "osca.def"

.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
		
	ld	a,l

	dec	a
	jr      nz,no_cursor

	call kjt_get_key
	ld	hl,0
	or a
	ret	z
	cp	' '
	jr	nz,no_fire1
	set	4,l
	ret
.no_fire1
	cp	$5a		; enter
	jr	nz,no_fire2
	set	5,l
	ret
.no_fire2
	cp	$6b
	jr	nz,noleft
	set	1,l
	ret
.noleft
	cp	$74
	jr	nz,noright
	set	0,l
	ret
.noright
	cp	$75
	jr	nz,noup
	set	3,l
	ret
.noup
	cp	$72
	jr	nz,nodown
	set	2,l
.nodown
	ret

.no_cursor
	in	a,(sys_joy_com_flags)
	ld	e,a
	rla
	rla
	and @00001100
	ld	b,a
	ld	a,e
	rra
	rra
	and @00000011
	ld	c,a
	ld	a,e
	and	@00110000
	or	b
	or	c
	ld	h,0
	ld	l,a
	ret
