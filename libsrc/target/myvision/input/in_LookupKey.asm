; uint in_LookupKey(uchar c)

SECTION code_clib
PUBLIC in_LookupKey
PUBLIC _in_LookupKey
EXTERN in_keytranstbl

; Given the ascii code of a character, returns the scan row and mask
; corresponding to the key that needs to be pressed to generate the
; character.  
;
; enter: L = ascii character code
; exit : L = scan row
;        H = mask
;        else: L = scan row, H = mask
; uses : AF,BC,HL

; The 16-bit value returned is a scan code understood by
; in_KeyPressed.

.in_LookupKey
._in_LookupKey
	ld	a,l
	ld	hl,in_keytranstbl
	ld	bc,32
	cpir
	jr	nz,notfound

	ld	a,31
	sub	c		;A = position in table
	ld	hl,0
	jr	not_shift

notfound:
	ld	hl,0
	scf
	ret
	

not_shift:
; Find the row byte
	ld	c,@01111111
shift:
	cp	8
	jr	c, got_it
	rrc	c
	sub	8	
	jr	shift
got_it:
	; a = Key number (0-7)
	; c = line number

	ld	h,@10000000
calc_mask:
	and	a
	jr	z,got_mask
	srl	h
	dec	a
	jr	calc_mask

got_mask:
	; h = mask
	; c = line number
	ld	l,c
	ret


