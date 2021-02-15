; uint in_LookupKey(uchar c)

SECTION code_clib
PUBLIC in_LookupKey
PUBLIC _in_LookupKey
EXTERN in_keytranstbl

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
	ld	de,0
	ld	b,96
loop1:
	cp	(hl)
	jp	z,gotit
	inc	hl
	dec	b
	jp	nz,loop1
	ld	e,128	;Shift
	ld	b,96
loop2:
	cp	(hl)
	jp	z,gotit
	inc	hl
	dec	b
	jp	nz,loop2
	ld	e,@01000000
	ld	b,96
loop3:
	cp	(hl)
	jp	z,gotit
	inc	hl
	dec	b
	jp	nz,loop3
notfound:
	ld	hl,0
	scf
	ret

; e = modifiers
; b = position within table
gotit:
	ld	a,96
	sub	b
	ld	b,a
	; Divide by 8 to find the row
	rrca
	rrca
	rrca
	and	15	;That gets the row
	or	e	;Ctrl/shift modifiers
	ld	e,a	;That's safe now
	; Now calculate the mask, 
	ld	a,b
	and	7
	ld	b,a
	ld	a,@00000001
	inc	b
maskloop:
	dec	b
	jp	z,got_mask
	rlca
	jp	maskloop
got_mask:
	ld	d,a
	ex	de,hl
	and	a
	ret

