; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
EXTERN CLIB_KEYBOARD_ADDRESS

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
	ld	a,0b01110000		;Select row 7
	out	($e0),a
	in	a,($c0)			;Read row 7
	cpl
	ld	c,@00100001
	bit	7,l
	jr	z,noshift
	bit	0,a
	jr	z,fail		;Shift not pressed
	res	0,c
  
.noshift
	bit	6,l
	jr	z,noctrl
	bit	5,a
	jr	z,fail		;Control not pressed
	res	5,c

.noctrl
	; Check that we've got the right number of modifier keys pressed
	and	c
	jr	nz,fail
	ld	a,l
	rlca
	rlca
	rlca
	rlca
	and	@01110000

	out	($e0),a		;Select row
	in	a,($c0)		;Read row
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


