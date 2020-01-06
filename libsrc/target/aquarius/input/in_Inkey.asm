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

.in_Inkey
._in_Inkey
	ld	bc,0xfeff
	ld	de,0
	ld	l,7
loop:
	in	a,(c)
	cpl
	and	@00111111
	jr	nz, gotkey
	rlc	b
	ld	a,e
	add	6
	ld	e,a
	dec	l
	jr	nz,loop
	in	a,(c)		;ROW7 has modifiers in it
	cpl	
	and	@00001111
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

	; Check for shift and control
	ld	hl, 48 * 2
	ld	bc,0x7fff
	in	a,(c)
	bit	5,a		;control
	jr	z, got_modifier
	ld	hl, 48
	bit	4,a		;shift
	jr	z,got_modifier
	ld	hl,0
got_modifier:
	add	hl,de
	ld	de,in_keytranstbl
	add	hl,de
	ld	a,(hl)
	cp	255
	jr	z, nokey
	ld	l,a
	ld	h,0
	and	a
	ret


