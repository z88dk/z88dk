; uint in_LookupKey(uchar c)
; 07.2018 suborb

SECTION code_clib
PUBLIC in_LookupKey
PUBLIC _in_LookupKey
EXTERN in_keytranstbl

; Given the ascii code of a character, returns the scan row and mask
; corresponding to the key that needs to be pressed to generate the
; character.  
;
; The scan row returned will have bit 7 set and bit 6 set to
; indicate if CAPS, SYM SHIFTS also have to be pressed to generate the
; ascii code, respectively.

; enter: L = ascii character code
; exit : L = scan row
;        H = mask
;        else: L = scan row, H = mask
;              bit 7 of L set if SHIFT needs to be pressed
;              bit 6 of L set if FUNC needs to be pressed
; uses : AF,BC,HL

; The 16-bit value returned is a scan code understood by
; in_KeyPressed.

.in_LookupKey
._in_LookupKey
	ld	a,l
	ld	hl,in_keytranstbl
	ld	bc,80 * 3
	cpir
	jr	nz,notfound

	ld	a,+(80 * 3) - 1
	sub	c		;A = position in table
	ld	hl,0
	cp	80 * 2
	jr	c,not_function_table
	sub	80 * 2
	set	6,l
	jr	shift

not_function_table:
	cp	80
	jr	c,shift
	sub	80
	set	7,l

shift:
	ld	h,a	;Save character
	srl	a	; Divide by 8
	srl	a
	srl	a
	or	l
	ld	l,a
	; calculate the mask now
	ld	a,h
	ld	h,128
shift_loop:
	and	7
	ret	z		; nc
	rr	h
	dec	a
	jr	shift_loop


notfound:
	ld	hl,0
	scf
	ret
