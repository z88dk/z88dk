; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
EXTERN CLIB_KEYBOARD_ADDRESS

; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

.in_KeyPressed
._in_KeyPressed
	ld	bc,0x7fff
	in	a,(c)
	ld	e,@00110000
	bit	7,l
	jr	z,noshift
	bit	4,a
	jr	nz,fail		;shift not pressed
 	res	4,e 
.noshift
	bit	6,l
	jr	z,noctrl
	bit	5,a
	jr	nz,fail
	res	5,e
.noctrl
	cpl		;MAke sure we don't have extra modifiers
	and	e
	jr	nz,fail
	ld	a,l
	ld	b,0xfe
map_loop:
	and	7
	jr	z,done
	rlc	b
	dec	a
	jr	map_loop
done:
	in	a,(c)
	cpl
	and	h		;Check with mask
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


