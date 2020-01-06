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
	ld	b,0		;Which modifiers we've got

	ld	a,@11111101	;SHIFT row
	out	(0xf8),a
	in	a,(0xfa)
	rlca
	jr	c,noshift
	set	7,b
.noshift
	ld	a,@11110111	;CTRL row
	out	(0xf8),a
	in	a,(0xfa)
	rlca
	jr	c,noctrl
	set	6,b

noctrl:
	ld	a,l		;The modifiers we want
	and	@11000000
	cp	b		;The modifiers we got
	jr	nz,fail

	ld	a,l
	ld	b,@11111110
rotate_loop:
	and	@00001111
	jr	z,rotate_done
	rlc	b
	dec	a
	jr	nz,rotate_loop

rotate_done:
	ld	a,b
	out	(0xf8),a
	in	a,(0xfa)
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


