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
	ld	h,$38
	ld	l,@11111110
	ld	a,e
	and	7
	inc	a
row_loop:
	rlc	l
	dec	a
	jr	nz,row_loop
	ld	a,(hl)			;Save it for a minute
	cpl
	and	d
	jr	z,fail
	; Now check if we need shift/control
	ld	b,0
	rlc	e			;7 = shift, 6 = control
	jr	nc,no_shift
	ld	b,@00000001
no_shift:
	rlc	e
	jr	nc,no_control
	set	1,b
no_control:
	ld	a,($38fe)
	cpl
	and	@00000011		;Isolate keys
	cp	b
	jr	nz,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


