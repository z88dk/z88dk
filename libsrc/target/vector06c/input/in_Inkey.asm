; uint in_Inkey(void)
; 06.2018 suborb

; Read current state of keyboard 

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl
EXTERN __vector06c_key_rows

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;
; TRS80/EACA2000 uses memory mapped keyboard ports

.in_Inkey
._in_Inkey
	ld	c,0
	ld	hl,__vector06c_key_rows
loop:
	ld	a,(hl)
	and	a
	jr	nz,gotkey
	inc	hl
	ld	a,c
	add	8
	ld	c,a
	cp	64
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
	ld	a,(__vector06c_key_rows+8)
	ld	hl,64
	and	@00100000		;Shift
	jr	nz,got_modifier
	ld	hl,128
	ld	a,(__vector06c_key_rows+8)
	and	@01000000		;Ctrl
	jr	nz,got_modifier
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


