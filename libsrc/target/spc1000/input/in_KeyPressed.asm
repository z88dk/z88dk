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
	ld	bc,$8000
	in	a,(c)
	cpl
	ld	c,@00000110	;Modifier keys
	bit	7,l
	jr	z,nocaps
	bit	1,a
	jr	z, fail	;Shift not pressed
	res	1,c
  
.nocaps
	bit	6,l
	jr	z,nofunc
	bit	2,a
	jr	z, fail	;Control not pressed
	res	2,c

.nofunc
	and	c		;If we have any modifiers set that we don't want, we fail
	jr	nz,fail
	ld	a,l
	and	15
	ld	c,a
	ld	b,$80
	in	a,(c)
	and	h		;Check with mask
	jr	nz,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


