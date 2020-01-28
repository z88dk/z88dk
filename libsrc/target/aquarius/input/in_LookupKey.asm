; uint in_LookupKey(uchar c)
; 06.2018 suborb

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
	ld	bc,48 * 3
	cpir
	jr	nz,notfound

	ld	a,+(48 * 3) - 1
	sub	c		;A = position in table
	ld	hl,0
	cp	48 * 2
	jr	c,not_function_table
	sub	48 * 2
	set	6,l
	jr	shift

not_function_table:
	cp	48
	jr	c,shift
	sub	48
	set	7,l

shift:
	; Need to divide by 6
	ld	b,255
div6loop:
	inc	b
	sub	6
	jr	nc,div6loop
	add	7		;bit position + 1
	ld	c,a
	ld	a,l
	or	b
	ld	l,a
	; l = line number + control/shift flags
	; c = bit_position + 1

        ld      h,@00100000
calc_mask:
        dec     c
	ret	z		; h = mask, l = flags
        and     a
        rr      h
        jr      calc_mask


notfound:
	ld	hl,0
	scf
	ret
