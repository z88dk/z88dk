; uint in_Inkey(void)
; 05.2018 suborb

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
; Sord M5 uses port 0x30 - 0x36
; in_keytranstbl is the wrong way round

.in_Inkey
._in_Inkey
	ld	de,0
	in	a,($30)
	and	@11000000	; Only care about space and enter
	jr	nz, gotkey
	ld	e,8
	in	a,($31)
	and	a
	jr	nz, gotkey
	ld	e,16
	in	a,($32)
	and	a
	jr	nz, gotkey
	ld	e,24
	in	a,($33)
	and	a
	jr	nz, gotkey
	ld	e,32
	in	a,($34)
	and	a
	jr	nz, gotkey
	ld	e, 40
	in	a,($35)
	and	a
	jr	nz, gotkey
	ld	e, 48
	in	a,($36)
	and	a
	jr	nz, gotkey
	ld	e,56
	in	a,($50)
	and	128
	jr	nz,gotkey
nokey:
	ld	hl,0	
	scf
	ret

gotkey:
    ; a = key pressed
    ; e = offset
	ld	c,8
hitkey_loop:
	rrca
	jr	c,doneinc
	inc	e
	dec	c
	jr	nz,hitkey_loop
doneinc:

	; Check for shift and control
	ld	bc, 64 * 2
	in	a,($30)
	bit	0,a		;Control
	jr	nz, got_modifier
	ld	bc, 64
	and	@00001100	;Both shift keys
	jr	nz,got_modifier
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


