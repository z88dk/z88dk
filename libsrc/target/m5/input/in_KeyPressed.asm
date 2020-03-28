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
	in	a,($30)
	ld	b,a
	ld	c,@00001101
	bit	6,l
	jr	z,no_control
	bit	0,a
	jr	z,fail
	res	0,c
no_control:
	bit	7,l
	jr	z,no_shift
	and	@00001100
	jr	z, fail
	res	2,c
	res	3,c
no_shift:
	ld	a,b	; Make sure we don't have unwanted modifiers pressed
	and	c
	jr	nz,fail

	ld	a,l
	and	@00111111
	ld	c,a
	in	a,(c)
	and	h
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


