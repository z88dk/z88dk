; uint in_Inkey(void)
; 10.2018 suborb

; Read current state of keyboard but only return
; keypress if a single key is pressed.

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL, af'
;

; Write bit corresponding to line to PIO port A 0xf9
; Read from pio port B 0xfa
; 

.in_Inkey
._in_Inkey
	; First four rows we mask off bit 7
	ld	b,4
	ld	de,0
	ld	a,@11111110
inkey_1:
	out	(0xf8),a
	ex	af,af
	in	a,(0xfa)
	cpl
	and	127
	jr	nz, gotkey
	ld	a,e
	add	8
	ld	e,a
	ex	af,af
	rlca
	djnz	inkey_1
	; The last 4 rows we have no need to mask off bit 7
	ld	b,4
inkey_2:
	out	(0xf8),a
	ex	af,af
	in	a,(0xfa)
	cpl
	and	255
	jr	nz, gotkey
	ld	a,e
	add	8
	ld	e,a
	ex	af,af
	rlca
	djnz	inkey_2
	; The last 4 rows we have no need to mask off bit 7
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
	ld	a,@11110111	;CTRL row
	out	(0xf8),a
	in	a,(0xfa)
	ld	bc, 64 * 2
	bit	7,a
	jr	z,got_modifier
	ld	c, 64
	ld	a,@11111101	;SHIFT row
	out	(0xf8),a
	in	a,(0xfa)
	bit	7,a
	jr	z,got_modifier
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


