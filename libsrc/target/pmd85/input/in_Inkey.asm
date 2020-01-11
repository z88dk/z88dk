; uint in_Inkey(void)
; 06.2018 suborb

; Read current state of keyboard 

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl
EXTERN CLIB_KEYBOARD_ADDRESS

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL
;
; TRS80/EACA2000 uses memory mapped keyboard ports

.in_Inkey
._in_Inkey
	ld	de,0
	ld	b,0		;modifiers are on last row...
loop:
	ld	a,b
	out	($f4),a
	in	a,($f5)
	cpl
	ld	c,a
	and	@00011111
	jr	nz,gotkey
	inc	b
	ld	a,e
	add	5
	ld	e,a
	cp	75
	jr	nz,loop
nokey:
	ld	hl,0
	scf
	ret

	

gotkey:
    ; a = key pressed
    ; c = key including modifiers
    ; e = offset
	ld	l,5
hitkey_loop:
	rrca
	jr	c,doneinc
	inc	e
	dec	l
	jr	nz,hitkey_loop
doneinc:
	ld	a,c
	ld	hl,75	
	and	@00100000		;Shift
	jr	nz,got_modifier
	ld	hl,150
	ld	a,c
	and	@01000000		;Ctrl
	jr	nz,got_modifier
	ld	hl,0
got_modifier:
	add	hl,de
	ld	de,in_keytranstbl
	add	hl,de
	ld	a,(hl)	
	cp	255
	jr	z,nokey
	ld	l,a
	ld	h,0
	and	a
	ret


