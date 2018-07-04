; uint in_Inkey(void)
; 06.2018 suborb


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
	ld	c,0
	; Read line 0 separately and exclude shift/control
	ld	a,c
	out	(254),a
	in	a,(254)
	cpl
	and	@00001011
	jr	nz,gotkey

	inc	c		; Move onto line 1
	ld	e,5
loop:
	ld	a,c
	out	(254),a
	in	a,(254)
	cpl
	and	@00011111
	jr	nz,gotkey
	ld	a,e
	add	5
	ld	e,a
	inc	c
	ld	a,c
	cp	16
	jr	nz,loop
nokey:
	ld	hl,0	
	scf
	ret

gotkey:
    ; a = key pressed
    ; e = offset
	rlca
	rlca	
	rlca
	ld	c,5
hitkey_loop:
	rlca
	jr	c,doneinc
	inc	e
	dec	c
	jr	nz,hitkey_loop
doneinc:

	; Check for shift and control
	ld	bc, 80 * 2
	ld	a,0
	out	(254),a
	in	a,(254)
	bit	2,a		;control
	jr	z,got_modifier
	ld	bc, 80
	bit	4,a
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


