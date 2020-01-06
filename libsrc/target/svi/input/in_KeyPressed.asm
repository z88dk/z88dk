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
	ld	a,6		;Row 6 = modifiers
	out	($96),a
	in	a,($99)
	cpl
	ld	b,a		;Save values
	ld	c,@00000011	;Shift + Ctrl set
	bit	6,l
	jr	z,no_control
	bit	1,a
	jr	z,fail
	res	1,c
no_control:
	bit	7,l
	jr	z,no_shift
	bit	0,a
	jr	z, fail
	res	0,c
no_shift:
	ld	a,b	; Make sure we don't have unwanted modifiers pressed
	and	c
	jr	nz,fail

	; Now get the row
	ld	a,l
	and	@00001111
	out	($96),a
	in	a,($99)
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


