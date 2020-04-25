; uint in_LookupKey(uchar c)

SECTION code_clib
PUBLIC in_LookupKey
PUBLIC _in_LookupKey
EXTERN in_keytranstbl

; enter: L = ascii character code
; exit : L = flags
;        H = port
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
	ld	bc,64 * 3
	cpir
	jr	nz,notfound

	ld	a,+(64 * 3) - 1
	sub	c		;A = position in table
	ld	c,a
	ld	hl,0
	cp	64 * 2
	jr	c,not_function_table
	sub	64 * 2
	ld	c,a
	set	6,h
	jr	continue

notfound:
	ld	hl,0
	scf
	ret
	

not_function_table:
	cp	64
	jr	c,continue
	sub	64
	ld	c,a
	set	7,h

continue:
	; h = flags
	; c = key index
        ld      l,c
	and	a
	ret
	

