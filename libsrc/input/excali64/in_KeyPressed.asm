; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
INCLUDE "target/cpm/def/excali64.def"

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
	ld	a,@11111110		;Shift row
        out     (PORT_KBD_ROW_SELECT),a
        in      a,(PORT_KBD_ROW_READ)
	bit	7,l
	jr	nz,want_shift
	bit	2,a
	jr	z,fail
	jr	consider_ctrl

want_shift:
	bit	2,a
	jr	nz,fail		;Shift not pressed
 
.consider_ctrl
	ld	a,@11111101
        out     (PORT_KBD_ROW_SELECT),a
        in      a,(PORT_KBD_ROW_READ)
	bit	6,l
	jr	nz,want_ctrl
	bit	4,a
	jr	z,fail
	jr	nofunc
.want_ctrl
	bit	4,a		;CTRL
	jr	nz,fail

.nofunc
	ld	a,l
	ld	c,@11111110
getrow_loop:
	and	15
	jr	z,done
	rlc	c
	dec	a
	jr	getrow_loop
done:
	ld	a,c
        out     (PORT_KBD_ROW_SELECT),a
        in      a,(PORT_KBD_ROW_READ)
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


