; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
EXTERN in_keyrowmap

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
	ld	c,@00010001
   	in	a,($e3)		; read modifiers
	cpl
	bit	7,l
	jr	z,nocaps
	bit	4,a
	jr	nz,fail			;CAPS not pressed
 	res	4,c 
.nocaps				;Checking control key
	bit	6,l
	jr	z,nofunc
	bit	0,a
	jr	nz,fail
	res	0,c

.nofunc
	and	c
	jr	nz,fail		;We had an unexpected modifier key pressed
	ex	de,hl
	ld	a,e
	and	15
	add	a
	ld	l,a
	ld	h,0
	ld	bc,in_keyrowmap
	add	hl,bc
	ld	c,(hl)
	in	a,(c)
	cpl
	and	d		;mask
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


