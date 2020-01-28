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

; write to ppi0 porta with key row (port 0xf4)
; Read from ppi0 portb with value (including shift/ctrl keys) (port 0xf5)
; Bit 5 = shift, Bit 6 = ctrl

.in_KeyPressed
._in_KeyPressed
	ld	a,l
	and	15
	out	($f4),a
	in	a,($f5)			;So we have the key
	cpl
	ld	c,a			;Save it for a minute
	and	h
	jr	z,fail
	ld	b,0
	ld	a,l			;7 = shift, 6 = control
	rlca
	jr	nc,no_shift
	ld	b,@00100000
no_shift:
	rlca
	jr	nc,no_control
	ld	a,b
	or	@01000000
	ld	b,a
no_control:
	ld	a,c			;What we read
	and	@01100000		;Isolate keys
	and	b			;Mask out what we want
	cp	b			;Is it what we want?
	jr	nz,fail
	ld	hl,1
	scf
	ret
fail:
	ld	hl,0
	and	a
	ret


