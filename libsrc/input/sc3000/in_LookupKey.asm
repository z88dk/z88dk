; uint in_LookupKey(uchar c)

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
;              bit 5 of L set if port $dd else $dc
; uses : AF,BC,HL

; The 16-bit value returned is a scan code understood by
; in_KeyPressed.

.in_LookupKey
._in_LookupKey
	ld	a,l
	ld	hl,in_keytranstbl
	ld	bc,84 * 3
	cpir
	jr	nz,notfound

	ld	a,+(84 * 3) - 1
	sub	c		;A = position in table
	ld	hl,0
	cp	84 * 2
	jr	c,not_function_table
	sub	84 * 2
	set	6,l
	jr	shift

notfound:
	ld	hl,0
	scf
	ret
	

not_function_table:
	cp	84
	jr	c,not_shift
	sub	84
	set	7,l

not_shift:
; Now we must divide by 12 to find out the row number
	ld	c,0	;row number
shift:
	cp	12
	jr	c, got_it
	inc	c
	sub	12
	jr	shift
got_it:
	; a = Key number (0-11)
	; c = line number
	; l = Shift/control flags

	ld	h,@10000000
	cp	4
	jr	nc, for_port_dc
	set	5,l		; We need to use port $dc
	ld	h,@00001000
	add	4		; We're going to take it off in a bit
for_port_dc:
	sub	4		;So normalised 0 - 3 or 0 - 7
	; Now calculate mask
calc_mask:
	and	a
	jr	z,got_mask
	rr	h
	dec	a
	jr	calc_mask

got_mask:
	; h = mask
	; c = line number
	; l = flags
	ld	a,l
	or	c
	ld	l,a
	ret


