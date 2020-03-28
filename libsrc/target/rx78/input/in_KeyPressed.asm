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
	ld	a, 8 + 1		;Read modifier row
	out	(0xf4),a
	ld	c,@00000101
	in	a,(0xf4)
	bit	7,l
	jr	z,nocaps
	bit	2,a
	jr	z,fail
	res	2,c
.nocaps
	bit	6,l
	jr	z,nofunc
	bit	0,a
	jr	z,fail
	res	0,c
.nofunc
	and	c
	jr	nz,fail
	ld	a,l
	and	15
	inc	a
	out	(0xf4),a
	in	a,(0xf4)
	and	h		;Check with mask
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


