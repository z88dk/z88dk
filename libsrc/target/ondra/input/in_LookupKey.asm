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
;              bit 7 of L set if SHIFT needs to be pressed
;              bit 6 of L set if CTRL needs to be pressed
; uses : AF,BC,HL

; The 16-bit value returned is a scan code understood by
; in_KeyPressed.

;
; 9 keyboard rows
; l CN$Sxxxx = scan row
; h 000xxxxx = mask
;
; Modifiers:
; Shift (UPPER)
; Number
; Symbol
; Ctrl (CS)


.in_LookupKey
._in_LookupKey
	ld	a,l
	ld	hl,in_keytranstbl
	ld	bc,45 * 5
	cpir
	jp	nz,notfound

	ld	a,+(45 * 5) - 1
	sub	c
	ld	c,a
	ld	hl,0
	cp	45 * 4
	jr	c,not_control_table
	set	4,l		;UPPER
	sub	45 * 4
	jr	shift
not_control_table:
	cp	45 * 3
	jr	c,not_symbol_table
	set	5,l		;SYMBOL
	sub	45 * 3
	jr	shift
not_symbol_table:
	cp	45 * 2
	jr	c,not_number_table
	set	6,l		;NUMBER
	sub	45 * 2
	jr	shift
not_number_table:
	cp	45 * 1
	jr	c,shift
	set	7,l
	sub	45
	jr	shift

shift:
	ld	h,a	;Save character
	ld	b,0xff
div5loop:
	inc	b
	sub	5
	jr	nc,div5loop
	add	5
	ld	h,a		;key
	ld	a,b
	or	l
	ld	l,a
	; Calculate the mask
	ld	a,h
	ld	h,1
shift_loop:
	and	7
	ret	z	;nc
	rl	h
	dec	a
	jr	shift_loop



	ld	l,c
	ld	h,b
	ld	bc,45
	ld	de,0
	and	a
	sbc	hl,bc
	jr	c,got_page	;unshifted
	ld	de,45
	and	a
	sbc	hl,bc
	jr	c,got_page	;shifted
	ld	de,45*2
	and	a
	sbc	hl,bc
	jr	c,got_page	;number
	ld	de,45*3
	and	a
	sbc	hl,bc
	jr	c,got_page	;symbols
	ld	de,45*4		;ctrl
got_page:
	ld	a,e
	add	45

	

not_function_table:
	cp	64
	jr	c,continue
	sub	64
	ld	c,a
	ld	a,l
	or	@10000000
	ld	l,a

continue:
	; l = flags
	; c = character
	; find the row divide by 5
	ld	a,c
	rrca
	rrca
	rrca
	and	7	;row number
	ld	h,a
	ld	a,c
	and	7

	; l = row number, a = character in row
	; find the mask
	ld	b,@00000001
	ld	e,a
find_mask:
	ld	a,e
	and	a
	jr	z,found_mask
	ld	a,b
	rlca
	ld	b,a
	dec	e
	jr	find_mask

found_mask:
	; l = modifiers
	; h = row number
	; b = mask
	ld	a,l
	or	h
        ld      l,a
	ld	h,b
	and	a
	ret
	

notfound:
	ld	hl,0
	scf
	ret
