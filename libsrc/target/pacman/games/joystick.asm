;
;	Game device library for the PacMan HW
;       Stefano Bodrato - 2/2017
;
;	$Id:$
;

	SECTION code_clib
        PUBLIC    joystick
        PUBLIC    _joystick



.joystick
._joystick
	;__FASTCALL__ : joystick no. in HL
		
	ld	a,l
	dec	a
	jr z,control1
	
	dec	a
	ret  nz
	
	; control2 = ((*in1)&0xf | (((*in1)&0x40)>>2))^0x1f;
	ld hl,$5040
	ld a,(hl)
	and $0f
	ld e,a
	ld hl,$5040
	ld a,(hl)
	rra	
	jr decode


	; control1 = ((*in0)&0xf | (((*in1)&0x20)>>1))^0x1f;
.control1
	ld hl,$5000
	ld a,(hl)
	and $0f
	ld e,a
	ld hl,$5040
	ld a,(hl)
.decode
	rra
	and $10
	or e
	xor $1f

;; --fFUDLR
	 
	ld l,0
	ld e,l
	ld b,a	; (fire keys)
	rra
	rl l	; UP
	rra
	rl e	; LEFT
	rra
	rl e	; RIGHT
	rra
	rl l	; DOWN
	ld a,3
	and e
	ld e,a
	ld a,b
	and $70
	or e
	ld e,a
	ld a,l
	rla
	rla
	and $0C
	or e
	ld l,a
	ld h,0
	ret
	
	
