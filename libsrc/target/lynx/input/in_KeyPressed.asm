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
	ld	bc,$0080		;Row 0
	in	a,(c)
	bit	7,l
	jr	nz,check_shift
	rlca
	jr	nc,fail
	jr	consider_ctrl

check_shift:
	rlca
	jr	c,fail		;Shift not pressed
 
.consider_ctrl
	ld	b,$02		;ROW 2
	in	a,(c)
	bit	6,l
	jr	nz,check_ctrl
	bit	6,a
	jr	z,fail
	jr	nofunc
.check_ctrl
	bit	6,a		;CTRL
	jr	z,fail

.nofunc
	ld	a,l
	and	15
	ld	b,a
	in	a,(c)
	cpl
	and	h		;Check with mask
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


