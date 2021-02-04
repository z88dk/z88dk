; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
EXTERN in_keytranstbl


; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row, bit 6 = control, bit 7 = shift
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
	cp	8
	jp	nc,second_keyboard_port
; Consider the first keyboard port
	ld	c,a
	ld	a,@11111110
	inc	c
calc_mask:
	dec	c
	jp	z,got_mask
	rlca
	jp	calc_mask
got_mask:
	; a = mask for key row
	out	($d0),a		;ppi1 port a
	in	a,($d1)		;ppi1 port b
scan_rejoin:
	cpl
	and	h
	jp	z,no_key

	ld	hl,1
	scf
	ret

check_modifiers:
	; Now we need to check for control + shift
	; Grab shift keys
	ld	a,@11110111	;Row 4
	out	($d0),a
	ld	a,($d1)
	cpl
	ld	d,a		;Save the whole row
	and	@00001000
	ld	e,a		;Right shift value keep
	ld	a,@01111111	;Now, rows 7
	out	($d0),a
	in	a,($d1)
	cpl
	and	@00000001
	or	e		;So if nz, shift is pressed
	ld	c,@10000000
	jp	nz,check_control
	ld	c,0

check_control:
	;d holds row 3
	;c holds shift status
	ld	a,d
	and	@00100000	;Pick out right control
	ld	e,a		;Save right control state
	ld	a,@10111111
	out	($d0),a
	in	a,($d1)
	cpl
	and	@00000010	;Pick out left control
	or	e		;So if nz, control is pressed
	ld	b,@01000000
	jp	nz,combine_modifiers
	ld	b,0
combine_modifiers:
	ld	a,c
	or	b
	ld	c,a		;c holds modifiers pressed
	ld	a,l		;bits 6,7 hold required modifiers
	and	@11000000
	cp	c
	jp	nz,no_key
	ld	hl,1
	scf
	ret
no_key:
	ld	hl,0
	and	a
	ret

second_keyboard_port:
	sub	8
	ld	c,a
        ld      a,@11111110
	inc	c
calc_mask2:
	dec	c
	jp	z,got_mask2
        rlca
	jp	calc_mask2
got_mask2:
        ; a = mask for key row
        out     ($d2),a         ;ppi1 port a
        in      a,($d2)         ;ppi1 port b
	jp	scan_rejoin
