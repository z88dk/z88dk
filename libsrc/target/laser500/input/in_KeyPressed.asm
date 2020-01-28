; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
EXTERN l_push_di
EXTERN l_pop_ei

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL
;
; Memory mapped io (in bank1, so 0x6b00 + )
; Row0-11 = fe, fc... rotate left


	INCLUDE	"target/laser500/def/laser500.def"

.in_KeyPressed
._in_KeyPressed
	call	l_push_di
	ld	a,2	
	out	($41),a

	ld	a,($6ffe)
	bit	7,l
	jr	nz,check_shift
	and	@01000000
	jr	z, fail
	jr 	consider_ctrl
check_shift:
	; We expect to be shifted, so fail if not
	and	@01000000
	jr	nz, fail

consider_ctrl:
	ld	a,($6ffc)
	bit	6,l
	jr	nz,check_ctrl
	rlca
	jr	nc,fail
	jr	check_actual_key
check_ctrl:
	rlca
	jr	c,fail

check_actual_key:
	; So now we can check the actual key that's been pressed
	call	getport
	ld	a,(de)
	cpl
	ld	l,a
	ld	a,(SYSVAR_bank1)
	out	($41),a
	call	l_pop_ei

	ld	a,l
	and	h		;nc
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0	
	and	a
	ret

; Figure out which port we should be reading from
getport:
	ld	de,$6ffe
	ld	a,l
	and	15
	cp	8
	jr	nc,ports_a_d
row_0_9_loop:
	and	a
	ret	z
	scf
	rl	e
	dec	a
	jr	row_0_9_loop
ports_a_d:
	sub	7		;So range 1 - 4
	neg			;-1 -> -4
	add	$6b
	ld	d,a
	ld	e,$ff
	ret
