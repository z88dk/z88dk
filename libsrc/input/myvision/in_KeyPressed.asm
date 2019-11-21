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
	; Write line to port b of the ay
	di
	ld	a,15
	out	($00),a
	ld	a,l
	out	($01),a
	ld	a,14
	out	($00),a
	; And we want to read port a of the AY
	in	a,($02)
	ei
	cpl
	and	h
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


