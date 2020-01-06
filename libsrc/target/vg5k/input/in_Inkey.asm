; uint in_Inkey(void)
; 06.2018 suborb

; Read current state of keyboard but only return
; keypress if a single key is pressed.

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;
; VG5k uses ports 0x80 - 0x87, active low

.in_Inkey
._in_Inkey
	ld	de,0
	in	a,($80)
	xor	255
	and	@10111001		;exclude shift/ctrl
	jr	nz, gotkey
	ld	e,8
	in	a,($81)
	xor	255
	jr	nz, gotkey
	ld	e,16
	in	a,($82)
	xor	255
	jr	nz, gotkey
	ld	e,24
	in	a,($83)
	xor	255
	jr	nz, gotkey
	ld	e,32
	in	a,($84)
	xor	255
	jr	nz, gotkey
	ld	e,40
	in	a,($85)
	xor	255
	jr	nz, gotkey
	ld	e,48
	in	a,($86)
	xor	255
	jr	nz, gotkey
	ld	e,56
	in	a,($87)
	xor	255
	jr	nz, gotkey
nokey:
	ld	hl,0	
	scf
	ret

gotkey:
    ; a = key pressed
    ; e = offset
	ld	c,8
hitkey_loop:
	rlca
	jr	c,doneinc
	inc	e
	dec	c
	jr	nz,hitkey_loop
doneinc:

	; Check for shift and control
	ld	bc, 64 * 2
	in	a,($80)
	bit	6,a		;Control
	jr	z, got_modifier
	ld	bc, 64
	bit	2,a		;shift key
	jr	z,got_modifier
	ld	bc,0
got_modifier:
	ld	hl,in_keytranstbl
	add	hl,bc
	add	hl,de
	ld	a,(hl)
	cp	255
	jr	z, nokey
	ld	l,a
	ld	h,0
	and	a
	ret


