; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter: L = mask + flags
;        H = port
;              bit 7 of L set if SHIFT needs to be pressed
;              bit 6 of L set if CTRL needs to be pressed
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
	ld	a,($68fb)
	bit	7,l
	jr	nz,check_shift
	bit	2,a
	jr	z,fail
	jr	start_control
check_shift:
	bit	2,a
	jr	nz,fail

start_control:
	ld	a,($68fd)
	bit	6,l
	jr	nz,check_control
	bit	2,a
	jr	z,fail
	jr	no_control
check_control:
	bit	2,a
	jr	nz,fail
no_control:
	; We've passed all requirements for modifiers, now find out what port
	ld	a,l
	and	@00111111
	ld	l,a
	ld	d,$68
	ld	e,h
	ld	a,(de)
	cpl
	and	l
	jr	z, fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


