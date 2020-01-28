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
;              bit 6 of L set if CTRL needs to be pressed
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
	jr	c,not_control
	set	6,l
	sub	80 * 2
	jr	gotit
not_control:
	cp	80
	jr	c, gotit
	set	7,l
	sub	80
	jr	gotit

notfound:
	ld	hl,0
	scf
	ret
	

; Now we must divide by 5 to find out the row number
gotit:
	ld	b,255
div5loop:
	inc	b
	sub	5
	jr	nc,div5loop
	add	6	;bit position + 1
	ld	c,a
	ld	a,l
	or	b
	ld	l,a
	; l = line number + control/shift flags
	; c = bit position + 1

	ld	h,@00010000
calc_mask:
	dec	c
	jr	z,got_mask
	and	a
	rr	h
	jr	calc_mask
got_mask:
	; h = mask
	; l = flags + line number
	ret


