; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
EXTERN in_keytranstbl


; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row, bit 7 = control, bit 6 = shift
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

; write to ppi1 porta with key row (port 0xd0)
; Read from ppi0 portb with value (including shift/ctrl keys) (port 0xd1)

; write to port c (d2) read from port c (d2) Rows 8-11

.in_KeyPressed
._in_KeyPressed
	ld	a,l
	and	15
	out	($82),a
	in	a,($81)
	cpl
	and	h
	jp	nz,check_modifiers
nokey:
	ld	hl,0
	and	a
	ret

check_modifiers:
	; Now we need to check for control + shift
	; Grab shift keys
	ld	a,6
	out	($82),a
	ld	a,($81)
	cpl
	and	@11000000
        ld      e,a     	;Save value
        ld      a,l
	rlca
	rlca
	and	@00000011
        cp      e
        jp      nz,nokey
	ld	hl,1
	scf
	ret
