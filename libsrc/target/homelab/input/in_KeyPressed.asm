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
	ex	de,hl	;de = input values
	ld	h,$e8
	ld	a,e
	and	15
	ld	l,a
	ld	a,(hl)			;Save it for a minute
	cpl
	and	d
	jr	z,fail
	; Now check if we need shift/control
	ld	b,0
	rlc	e			;7 = shift, 6 = control
	jr	nc,no_shift
	ld	a,($e802)
	cpl
	and	@00000110
	jr	z,fail
	ld	b,a
no_shift:
	rlc	e
	jr	nc,no_control
	set	3,b
no_control:
	ld	a,($e802)			;What we read
	cpl
	and	@00001110		;Isolate keys
	cp	b			;Is it what we want?
	jr	nz,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


