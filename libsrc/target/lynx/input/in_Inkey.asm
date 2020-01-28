; uint in_Inkey(void)
; 09.2018 suborb

; Read current state of keyboard 

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
	ld	bc,$0080
	ld	de,0
	in	a,(c)		;Row0
	cpl
	and	@00110001
	jr	nz,gotkey
	inc	b
	ld	e,8
	ld	l,9
loop:
	in	a,(c)		;Row1
	cpl
	and	@00111111
	jr	nz,gotkey
	inc	b		;Row 2
	ld	a,e
	add	8
	ld	e,a
	dec	l
	jr	nz,loop
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
	ld	d, 80 * 2
	ld	bc, $0280		;LINE 2
	in	a,(c)
	cpl
	and	@01000000
	jr	nz,got_modifier
	ld	d, 80
	ld	bc, $0080		;Line 0
	in	a,(c)
	rlca				;Shift
	jr	nc,got_modifier
	ld	d,0

got_modifier:
	ld	hl,in_keytranstbl
	ld	c,d
	ld	b,0
	add	hl,bc
	ld	d,0
	add	hl,de
	ld	a,(hl)
	cp	255
	jr	z, nokey
	ld	l,a
	ld	h,0
	and	a
	ret


