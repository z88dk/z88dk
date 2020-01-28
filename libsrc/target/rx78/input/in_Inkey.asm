; uint in_Inkey(void)
; 07.2018 suborb

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

.in_Inkey
._in_Inkey
	ld	de,0
	ld	b,9
	ld	c,0xf4
	ld	h,1
loop:
	out	(c),h
	in	a,(c)
	and	a
	jr	nz,gotkey
	inc	h
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
	rlca
	jr	c,doneinc
	inc	e
	dec	c
	jr	nz,hitkey_loop
doneinc:

	; Check for shift and control
	ld	a, 8 + 1	;Modifier row
	out	(0xf4),a
	in	a,(0xf4)
	ld	bc, 72 * 2
	bit	0,a
	jr	nz,got_modifier
	ld	c, 72
	bit	2,a
	jr	nz,got_modifier
	ld	c,0
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


