; uint in_Inkey(void)
; 06.2018 suborb

; Read current state of keyboard 

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl
EXTERN CLIB_KEYBOARD_ADDRESS

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;
; TRS80/EACA2000 uses memory mapped keyboard ports

.in_Inkey
._in_Inkey
	ld	de,0
	ld	b,8		;modifiers are on last row...
	inc	hl
loop:
	ld	a,8
	sub	b
	rlca
	rlca
	rlca
	rlca
	out	($e0),a
	in	a,($c0)
	cpl
	and	a
	jr	nz,gotkey
	ld	a,e
	add	8
	ld	e,a
	djnz	loop
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
	ld	a,@01110000		;Select modifier row
	out	($e0),a
	in	a,($c0)
	ld	bc, 64 * 2
	bit	5,a		;Control
	jr	z, got_modifier
	ld	bc, 64
	bit	0,a
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


