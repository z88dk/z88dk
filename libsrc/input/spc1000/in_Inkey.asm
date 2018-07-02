; uint in_Inkey(void)
; 07.2018 suborb

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
	; First row is control codes
	ld	de, 8
	ld	bc,$8001
	in	a,(c)
	cpl
	and	@11111111
	jr	nz,gotkey
	inc	bc		;8002
	ld	e,16
	in	a,(c)
	cpl
	and	@11111101
	jr	nz,gotkey
	inc	bc		;8003
	ld	e,24
	in	a,(c)
	cpl
	and	@11111101
	jr	nz,gotkey
	inc	bc		;8004
	ld	e,32
	in	a,(c)
	cpl
	and	@11111100
	jr	nz,gotkey
	inc	bc		;8005
	ld	e,40
	in	a,(c)
	cpl
	and	@11110110
	jr	nz,gotkey
	inc	bc		;8006
	ld	e,48
	in	a,(c)
	cpl
	and	@11111110
	jr	nz,gotkey
	inc	bc		;8007
	ld	e,56
	in	a,(c)
	cpl
	and	@11111110
	jr	nz,gotkey
	inc	bc		;8008
	ld	e,64
	in	a,(c)
	cpl
	and	@11111110
	jr	nz,gotkey
	inc	bc		;8009
	ld	e,72
	in	a,(c)
	cpl
	and	@11111110
	jr	nz,gotkey
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
	ld	bc,$8000
	in	a,(c)
	ld	bc, 80 * 2
	bit	2,a	; CTRL
	jr	z,got_modifier
	ld	bc, 80
	bit	1,a	;SHIFT
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


