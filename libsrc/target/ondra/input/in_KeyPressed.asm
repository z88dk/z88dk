; uint in_KeyPressed(uint scancode)

SECTION code_clib
PUBLIC in_KeyPressed
PUBLIC _in_KeyPressed
EXTERN __vector06c_key_rows


; Determines if a key is pressed using the scan code
; returned by in_LookupKey.

; enter : l = scan row
;         h = key mask
; exit  : carry = key is pressed & HL = 1
;         no carry = key not pressed & HL = 0
; used  : AF,BC,HL

; 9 keyboard rows
; l CN$Sxxxx = scan row
; h 000xxxxx = mask
;
; Modifiers:
; Shift (UPPER)
; Number
; Symbol
; Ctrl (CS)

.in_KeyPressed
._in_KeyPressed
	ex	de,hl
        ld      a,@111
        out     (3),a
	ld	a,e
	and	@00001111
	ld	l,a
	ld	h,$e0
	ld	a,(hl)
	cpl
	and	d
	jr	nz,check_modifiers
fail:
	ld	a,@001
	out	(3),a
	ld	hl,0
	and	a
	ret

; l CN$Sxxxx = scan row
check_modifiers:
	ld	a,($e004)
	ld	h,a
	xor	a
	bit	1,h	;number key
	jr	nz,not_number
	set	6,a
not_number:
	bit	4,h	;upper key
	jr	nz,not_upper
	set	4,a
not_upper:
	bit	2,h	;CS key
	jr	nz,not_control
	set	7,a
not_control:
	ld	c,a
	ld	a,($e002)
	bit	4,a	;Symbol key
	jr	nz,not_shift
	set	5,c
not_shift:
	ld	a,e
	and	@11110000
	cp	c
	jr	nz,fail
	ld	a,@001
	out	(3),a
	ld	hl,1
	scf
	ret

