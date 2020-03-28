; uint in_Inkey(void)
; 03.2019 suborb

; Read current state of keyboard but only return
; keypress if a single key is pressed.

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl
EXTERN in_rowtable
EXTERN	l_push_di
EXTERN	l_pop_ei

INCLUDE "target/cpm/def/excali64.def"

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;

.in_Inkey
._in_Inkey
	ld	e,0
	ld	a,@11111110
	out	(PORT_KBD_ROW_SELECT),a
	in	a,(PORT_KBD_ROW_READ)
	cpl
	and	@11111011		;avoid shift
	jr	nz,gotkey
	ld	e,8
	ld	a,@11111101
	out	(PORT_KBD_ROW_SELECT),a
	in	a,(PORT_KBD_ROW_READ)
	cpl
	and	@11101111	;Avoid CTRL
	jr	nz,gotkey
	ld	c,@11111011
	ld	e,16
	ld	b,6
read_loop:
	ld	a,c
	out	(PORT_KBD_ROW_SELECT),a
	in	a,(PORT_KBD_ROW_READ)
	xor	255
	jr	nz,gotkey
	ld	a,8
	add	e
	ld	e,a
	rlc	c
	djnz	read_loop
nokey:
	ld	hl,0	
	scf
	ret
	


gotkey:
    ; a = key pressed
    ; e = offset
	ld	c,8
hitkey_loop:
	rrca
	jr	c,doneinc
	inc	e
	dec	c
	jr	nz,hitkey_loop
doneinc:

	; Check for shift and control
	ld	bc, 64 * 2
	ld	a,@11111101	;Row 2
	out	(PORT_KBD_ROW_SELECT),a
	in	a,(PORT_KBD_ROW_READ)
	bit	4,a
	jr	z,got_modifier
	ld	bc, 64		;Now for shift
	ld	a,@11111110	;Row 1
	out	(PORT_KBD_ROW_SELECT),a
	in	a,(PORT_KBD_ROW_READ)
	bit	2,a
	jr	z,got_modifier
	ld	bc,0
got_modifier:
	ld	hl,in_keytranstbl
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


