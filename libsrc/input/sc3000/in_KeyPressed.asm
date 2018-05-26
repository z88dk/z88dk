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
        in      a,($de)
        and     248
        or      6
        out     ($de),a
        in      a,($dd)
	bit	7,l
	jr	z,no_shift
	bit	3,a
	jr	nz,fail
no_shift:
	bit	6,l
	jr	z,no_control
	bit	2,a
	jr	nz,fail
no_control:
	; We've passed all requirements for modifiers, now find out what port
	ld	a,l	; Select the key row
	and	7
	ld	c,a
	in	a,($de)
	and	248
	or	c
	out	($de),a
	ld	c,$dc
	bit	5,l
	jr	z,read_port
	ld	c,$dd
read_port:
	in	a,(c)
	cpl
	and	h		;Mask
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


