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
	ld	de,0
	ld	hl, $68FE
	ld	a,(hl)
	cpl
	and	@00111111
	jr	nz,gotkey
	ld	e,6
	ld	l,$FD
	ld	a,(hl)
	cpl
	and	@00111011
	jr	nz,gotkey
	ld	e,12
	ld	l,$fb
	ld	a,(hl)
	cpl
	and	@00111011
	jr	nz,gotkey
	ld	e,18
	ld	l,$f7
	ld	a,(hl)
	cpl
	and	@00111111
	jr	nz,gotkey
	ld	e,24
	ld	l,$ef
	ld	a,(hl)
	cpl
	and	@00111111
	jr	nz,gotkey
	ld	e,30
	ld	l,$df
	ld	a,(hl)
	cpl
	and	@00111111
	jr	nz,gotkey
	ld	e,36
	ld	l,$bf
	ld	a,(hl)
	cpl
	and	@00111111
	jr	nz,gotkey
	ld	e,42
	ld	l,$7f
	ld	a,(hl)
	cpl
	and	@00111111
	jr	nz,gotkey
nokey:
	ld	hl,0	
	scf
	ret


gotkey:
    ; a = key pressed
    ; e = offset
	rlca
	rlca
	ld	c,6
hitkey_loop:
	rlca
	jr	c,doneinc
	inc	e
	dec	c
	jr	nz,hitkey_loop
doneinc:
	; de = offset into table

	; Check for shift, control
	ld	bc,48 * 1	;Check for shift
	ld	a,($68fb)
	bit	2,a
	jr	nz,try_control
	ld	a,($68fd)
	bit	2,a
	jr	nz,found_modifier
	ld	bc,48 * 3	;Shift + control
	jr	found_modifier

try_control:
	ld	bc,48 * 2	;Control
	ld	a,($68fd)
	bit	2,a
	jr	z,found_modifier
	ld	bc,0		;Unshifted, no modifier
found_modifier:
	ld	hl,in_keytranstbl
	add	hl,de
	add	hl,bc
	ld	a,(hl)
	cp	255
	jr	z, nokey
	ld	l,a
	ld	h,0
	and	a
	ret


