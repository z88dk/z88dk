; uint in_Inkey(void)

; Read current state of keyboard 

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

.in_Inkey
._in_Inkey
	ld	c,0
	ld	hl,$38fd
loop:
	ld	a,(hl)
	xor	255
	jr	nz,gotkey
continue:
	rlc	l
	ld	a,c
	add	8
	ld	c,a
	cp	56
	jr	nz,loop
nokey:
	ld	hl,0
	scf
	ret

	

gotkey:
    ; c = offset
	ld	l,8
hitkey_loop:
	rrca
	jr	c,doneinc
	inc	c
	dec	l
	jr	nz,hitkey_loop
doneinc:
	ld	b,0
	ld	a,($38fe)
	bit	0,a
	ld	hl,56
	jr	z,got_modifier
	ld	hl,112
	bit	1,a
	jr	z,got_modifier
	ld	hl,0
got_modifier:
	add	hl,bc
	ld	bc,in_keytranstbl
	add	hl,bc
	ld	a,(hl)	
	cp	255
	jr	z,nokey
	ld	l,a
	ld	h,0
	and	a
	ret


