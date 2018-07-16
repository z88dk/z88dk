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
	ld	c,$44
	bit	7,l
	jr	z,nocaps
   	in	a,($80)		; check on shift key
	and	$04
	jr	nz,fail		;CAPS not pressed
	res	2,c
  
.nocaps
	bit	6,l
	jr	z,nofunc
	in	a,($80)
	and	$40
	jr	nz,fail
	res	6,c

.nofunc
	; Check we've got the right modifiers on
	in	a,($80)
	cpl
	and	c
	jr	nz,fail

	; And now scan
	ld	a,l
	and	15
	add	$80
	ld	c,a
	ld	b,0
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


