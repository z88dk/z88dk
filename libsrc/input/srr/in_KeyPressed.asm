; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
	ld	a,0
	out	(254),a
	in	a,(254)
	ld	c,@00010100
	bit	6,l
	jr	z,no_control
	bit	2,a
	jr	nz,fail
	res	2,c
no_control:
	bit	7,l
	jr	z,no_shift
	bit	4,a
	jr	nz, fail
	res	4,c
no_shift:
	cpl		; Any erroneous modifiers pressed?
	and	c
	jr	nz,fail
	ld	a,l
	and	@00011111
	out	(254),a
	in	a,(254)
	cpl
	and	h
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


