; uint in_Inkey(void)
; 09.2018 suborb

; Read current state of keyboard 

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl
EXTERN l_push_di
EXTERN l_pop_ei

INCLUDE "target/laser500/def/laser500.def"

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;

.in_Inkey
._in_Inkey
	call	l_push_di
	ld	a,2
	out	($41),a

	ld	hl,$6ffe
	ld	e,0
	ld	a,(hl)
	cpl
	and	63
	jr	nz,gotkey
	ld	l,$fd
	ld	e,7
	ld	a,(hl)
	cpl
	and	63
	jr	nz,gotkey


	ld	l,$fb
	ld	b,6
	ld	e,14
row_loops:
	ld	a,(hl)
	cpl
	and	127
	jr	nz,gotkey
	ld	a,e
	add	7
	ld	e,a
	scf
	rl	l
	djnz	row_loops

   ; scan the extra rows

	ld	hl,$6bff
	ld	b,4
row_loops_2:
	ld	a,(hl)
	cpl
	and	127
	jr	nz,gotkey
	ld	a,e
	add	7
	ld	e,a
	dec	h
	djnz	row_loops_2

	ld	a,(SYSVAR_bank1)
	out	($41),a
	call	l_pop_ei
nokey:
	ld	hl,0	
	scf
	ret

gotkey:
    ; a = key pressed
    ; e = offset
	ld	c,7
	rlca		;Discard bit 7
hitkey_loop:
	rlca
	jr	c,doneinc
	inc	e
	dec	c
	jr	nz,hitkey_loop
doneinc:

	; Check for shift and control
	ld	d, 84 * 2		;CTRL MODIFIER
	ld	hl,$6bfd		;ROW1
	bit	6,(hl)
	jr	z,got_modifier
	ld	d,84
	ld	l,$fe			;ROW0, left shift
	bit	6,(hl)
	jr	z,got_modifier
	ld	d,0

got_modifier:
	ld	a,(SYSVAR_bank1)
	out	($41),a
	call	l_pop_ei

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


