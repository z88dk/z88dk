; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
EXTERN in_getrow
INCLUDE "target/pasopia7/def/pasopia7.def"

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
	ld	a,@00010001		;Shift row
	out	(KEY_SCAN),a
	in	a,(KEY_DATA)
	bit	7,l
	jr	nz,check_shift
	bit	1,a
	jr	z,fail
	jr	consider_ctrl

check_shift:
	bit	1,a
	jr	nz,fail		;Shift not pressed
 
.consider_ctrl
	bit	6,l
	jr	nz,check_ctrl
	bit	0,a
	jr	z,fail
	jr	nofunc
.check_ctrl
	bit	0,a		;CTRL
	jr	nz,fail

.nofunc
	call	in_getrow
	out	(KEY_SCAN),a
	in	a,(KEY_DATA)
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


