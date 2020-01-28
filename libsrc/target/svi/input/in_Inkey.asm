; uint in_Inkey(void)
; 08.2018 suborb

; Read current state of keyboard but only return
; keypress if a single key is pressed.

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

read_row:
	inc	d
	ld	a,d
	out	($96),a
	in	a,($99)
	cpl
	and	a
	ret

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;

.in_Inkey
._in_Inkey
	ld	d,255	
	ld	e,0
	call	read_row	;Row 0
	jr	nz,gotkey
	ld	e,8
	call	read_row	;Row 1
	jr	nz,gotkey
	ld	e,16
	call	read_row	;Row 2
	jr	nz,gotkey
	ld	e,24
	call	read_row	;Row 3
	jr	nz,gotkey
	ld	e,32
	call	read_row	;Row 4
	jr	nz,gotkey
	ld	e,40
	call	read_row	;Row 5
	jr	nz,gotkey
	ld	e,48
	call	read_row	;Row 6
	and	@11111100	;Exclude shift and control keys
	jr	nz,gotkey
	ld	e,56
	call	read_row	;Row 7
	jr	nz,gotkey
	ld	e,64
	call	read_row	;Row 8
	jr	nz,gotkey
nokey:
	ld	hl,0		;No key pressed
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
	; e = offset in table

	; Check for shift and control
	ld	a,6
	out	($96),a
	in	a,($99)
	cpl

	ld	bc, 72 * 2
	bit	1,a		;Control
	jr	nz, got_modifier
	ld	bc, 72
	bit	0,a
	jr	nz,got_modifier
	ld	bc,0
got_modifier:
	ld	d,0
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


