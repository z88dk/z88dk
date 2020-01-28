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

.in_Inkey
._in_Inkey
	ld	hl,0
	ld	c,0
loop:
	in	a,($de)
	and	248
	or	c
	out	($de),a
	in	a,($dd)
	cpl
	and	15
	jr	nz,gotkey_port_dd
	inc	l
	inc	l
	inc	l
	inc	l
	in	a,($dc)
	cpl
	and	a
	jr	nz,gotkey
	ld	a,8
	add	l
	ld	l,a
	inc	c
	ld	a,c
	cp	8
	jr	nz,loop
nokey:
	ld	hl,0
	scf
	ret

gotkey_port_dd:
	rlca
	rlca
	rlca
	rlca
gotkey:
    ; a = key pressed
    ; l = offset
	ld	c,8
hitkey_loop:
	rlca
	jr	c,doneinc
	inc	l
	dec	c
	jr	nz,hitkey_loop
doneinc:

	; Check for shift, control
	ld	bc,84 * 2
	in	a,($de)
	and	248
	or	6
	out	($de),a
	in	a,($dd)
	bit	2,a
	jr	z,found_modifier
	ld	bc,84
	bit	3,a
	jr	z,found_modifier
	ld	bc,0
found_modifier:
	add	hl,bc
	ld	bc,in_keytranstbl
	add	hl,bc
	ld	a,(hl)
	cp	255
	jr	z, nokey
	ld	l,(hl)
	ld	h,0
	and	a
	ret


