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
	bit	7,l
	jr	z,nocaps
	ld	bc,$8000
	in	a,(c)
	bit	1,a
	jr	nz, fail	;Shift not pressed
  
.nocaps
	bit	6,l
	jr	z,nofunc
	ld	bc,$8000
	in	a,(c)
	bit	2,a
	jr	nz, fail	;Shift not pressed

.nofunc
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


