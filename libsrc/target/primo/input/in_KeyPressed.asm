; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
EXTERN CLIB_KEYBOARD_ADDRESS

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = flags
;         h = port
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
	ld	c,h
	ld	b,0
	in	a,(c)
	rrca
	jr	nc,fail

	; Now we should check shift/control keys
	in	a,(3)	;Shift
	rrca
	rr	b
	in	a,(7)	;Control
	rrca
	rr	b
	ld	a,b
	cp	l
	jr	nz,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


