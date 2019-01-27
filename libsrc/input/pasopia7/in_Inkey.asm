; uint in_Inkey(void)
; 06.2018 suborb

; Read current state of keyboard but only return
; keypress if a single key is pressed.

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl
EXTERN in_rowtable
EXTERN	l_push_di
EXTERN	l_pop_ei

INCLUDE "target/pasopia7/def/pasopia7.def"

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;

.in_Inkey
._in_Inkey
	call	l_push_di
	ld	b,12
	ld	hl,in_rowtable
	ld	de,0
read_loop:
	ld	a,(hl)
	ld	c,a
	inc	hl
	out	(KEY_SCAN),a
	in	a,(KEY_DATA)
	cpl
	and	a
	jr	nz,gotkey
	ld	a,e
	add	8
	ld	e,a
	djnz	read_loop
nokey:
	ld	hl,0	
	call	l_pop_ei
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
	ld	bc, 96 * 2
        ld      a,@00010001             ;Modifer row
        out     (KEY_SCAN),a
        in      a,(KEY_DATA)
	bit	0,a		;Control
	jr	z, got_modifier
	ld	bc, 96
	bit	1,a		;shift key
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
	call	l_pop_ei
	and	a
	ret


