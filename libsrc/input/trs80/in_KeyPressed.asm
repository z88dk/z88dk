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
	ld	c,@00010111
	bit	7,l
	jr	z,noshift
	ld	a,(CLIB_KEYBOARD_ADDRESS + 0x80)
	and	@00000011
	jr	z,fail		;shift not pressed
	ld	c,@00010100
  
.noshift
	bit	6,l
	jr	z,noctrl
	ld	a,(CLIB_KEYBOARD_ADDRESS + 0x80)
	and	@00010100
	jr	z,fail
	res	2,c
	res	4,c

.noctrl
	; Check that we've got the right number of modifier keys pressed
	ld	a,(CLIB_KEYBOARD_ADDRESS + 0x80)
	and	c
	jr	nz,fail
	ld	a,l
	ld	b,1
map_loop:
	and	15
	jr	z,done
	rl	b
	dec	a
	jr	map_loop
done:
	ld	de,CLIB_KEYBOARD_ADDRESS
	ld	a,b
	add	e
	ld	e,a
	ld	a,(de)
	and	h		;Check with mask
	jr	z,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


