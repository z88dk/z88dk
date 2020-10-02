; uint in_Inkey(void)

; Read current state of keyboard 

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;

.in_Inkey
._in_Inkey
	ld	a,@111
	out	(3),a

	ld	de,0

; row 2, bit 4 = shift
; row 4, vit 2 = num, bit3 = cs, bit4  = upper
; row 7, bit 4 = ctrl

	ld	hl,0xe000	;memory mapped from here
scan_row:
	ld	c,@00001111	;mask out control
	ld	a,l
	cp	7
	jr	z,scan
	ld	c,@00000000	;no interesting keys
	cp	4
	jr	z,scan
	ld	c,@00001111	;mask off shift
	cp	2
	jr	z,scan
	ld	c,@00011111	;interested in all keys
scan:
	ld	a,(hl)
	cpl
	and	c
	jr	nz,gotkey
	inc	l
	ld	a,e
	add	5
	ld	e,a
	cp	45
	jr	nz,scan_row
nokey:
	ld	hl,0
	scf
return:
	ld	a,@001
	out	(3),a
	ret


gotkey:
	; e = row offset
	; a = key scan
	rrca
	jr	c,rotated
	inc	e
	jr	gotkey
rotated:

	; Now we have to detect the modifier keys
	ld	hl,in_keytranstbl + (3 * 45)
	ld	a,($e002)
	bit	4,a		;Symbol
	jr	z,got_modifier
	ld	a,($e004)
	ld	hl,in_keytranstbl + (2 * 45)
	bit	1,a		;Number key
	jr	z,got_modifier
	ld	hl,in_keytranstbl + (1 *45)
	bit	4,a		;UPPER key
	jr	z,got_modifier
	ld	hl,in_keytranstbl + (4 * 45)
	bit	2,a		;CS key
	jr	z,got_modifier
	ld	hl,in_keytranstbl
got_modifier:
	add	hl,de
	ld	a,(hl)
	cp	255
	jr	z,nokey
	ld	l,a
	ld	h,0
	and	a
	jr	return
