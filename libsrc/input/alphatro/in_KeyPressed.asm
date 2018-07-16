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
	in	a,($2a)
	bit	7,l
	jr	nz,check_shift
	bit	2,a
	jr	nz,fail
	jr	consider_ctrl

check_shift:
	bit	2,a
	jr	z,fail		;Shift not pressed
 
.consider_ctrl
	in	a,($29)
	bit	6,l
	jr	nz,check_ctrl
	bit	5,a
	jr	nz,fail
	jr	nofunc
.check_ctrl
	jr	z,nofunc
	bit	5,a		;CTRL
	jr	z,fail

.nofunc
	ld	a,l
	and	15
	neg
	add	$2b
	ld	c,a
	ld	b,0
	in	a,(c)
	and	h		;Check with mask
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


