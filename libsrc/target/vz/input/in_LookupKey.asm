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
; exit : L = mask + flags
;        H = port
;              bit 7 of L set if SHIFT needs to be pressed
;              bit 6 of L set if CTRL needs to be pressed
; uses : AF,BC,HL

; The 16-bit value returned is a scan code understood by
; in_KeyPressed.

.in_LookupKey
._in_LookupKey
	ld	a,l
	ld	hl,in_keytranstbl
	ld	bc,48 * 4
	cpir
	jr	nz,notfound

	ld	a,+(48 * 4) - 1
	sub	c		;A = position in table
	ld	de,0
	cp	48 * 3
	jr	c, not_control_shift
	ld	e,@11000000
	jr	done
not_control_shift:
	cp	48 * 2
	jr	c, not_control
	ld	e,@01000000
	jr	done
not_control:
	cp	48 
	jr	c, done
	ld	e,@10000000
done:
	; e = modifier flags
	; a = key offset
	; Need to divide by 6 and figure out port
	ld	c,255
find_offset_loop:
	inc	c
	sub	6
	jr	nc,find_offset_loop
	; Now calculate the mask of the residue
	add	6
	ld	b,@00100000
find_mask_loop:
	and	a
	jr	z,found_mask
	srl	b
	dec	a
	jr	find_mask_loop
found_mask:
	; b  = mask
	; e = modifier flags
	ld	a,e
	or	b
	ld	e,a		; e = mask + modifier flags

	ld	d,@11111110
	ld	a,c
find_port_loop:
	and	a
	jr	z,got_port
	rlc	d
	dec	a
	jr	find_port_loop
got_port:
	ex	de,hl		; and into correct return values
	and	a
	ret
notfound:
	ld	hl,0
	scf
	ret

