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

.in_Inkey
._in_Inkey
	ld	de,0
	in	a,($2b)
	and	@11111100
	jr	nz, gotkey
	ld	e,8
	in	a,($2a)
	and	@11111010
	jr	nz, gotkey
	ld	e,16
	in	a,($29)
	and	@00101111
	jr	nz, gotkey
	ld	e,24
	in	a,($28)
	and	@11111100
	jr	nz, gotkey
	ld	e,32
	in	a,($27)
	and	a
	jr	nz, gotkey
	ld	e,40
	in	a,($26)
	and	a
	jr	nz, gotkey
	ld	e,48
	in	a,($25)
	and	a
	jr	nz, gotkey
	ld	e,56
	in	a,($24)
	and	a
	jr	nz, gotkey
	ld	e,64
	in	a,($23)
	and	a
	jr	nz, gotkey
	ld	e,72
	in	a,($22)
	and	a
	jr	nz, gotkey
	ld	e,80
	in	a,($21)
	and	a
	jr	nz, gotkey
	ld	e,88
	in	a,($20)
	and	a
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
	ld	bc, 96 * 2
	in	a,($29)
	bit	6,a		;Control
	jr	nz, got_modifier
	ld	bc, 96
	in	a,($2a)
	bit	2,a		;shift key
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


