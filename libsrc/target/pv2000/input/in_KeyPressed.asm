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
	ld	c,@00000110
   	in	a,($40)		; read modifiers
	bit	7,l
	jr	z,nocaps
	bit	2,a
	jr	z,fail			;CAPS not pressed
 	res	2,c 
.nocaps
	bit	6,l
	jr	z,nofunc
	bit	1,a
	jr	z,fail
	res	1,c

.nofunc
	and	c
	jr	nz,fail		;We had an unexpected modifier key pressed

	ld	a,l
	and	15
	out	($20),a

	in	a,($20)
	rrca
	rrca
	rrca
	rrca
	and	240
	ld	c,a
	in	a,($10)
	and	15
	or	c
	and	h		;Check with mask
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


