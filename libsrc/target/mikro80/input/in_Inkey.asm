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
; TRS80/EACA2000 uses memory mapped keyboard ports

.in_Inkey
._in_Inkey
	ld	de,0
	ld	b,@11111110
loop:
	ld	a,b
	out	($07),a
	in	a,($06)
	cpl			;active low keyboard
	and	@01111111
	jr	nz,gotkey
	ld	a,e
	add	8
	ld	e,a
	ld	a,b
	rlca			;carry is cleared by the add 8
	ld	b,a
	jr	c,loop
nokey:
	ld	hl,0
	scf
	ret

	

gotkey:
    ; a = key pressed mask
    ; e = offset
	ld	l,7
hitkey_loop:
	rrca
	jr	c,doneinc
	inc	e
	dec	l
	jr	nz,hitkey_loop
	jr	nokey

doneinc:
	; e = offset
	in	a,($05)			;shift/ctrl row
	cpl
	ld	c,a
	ld	hl,64
	and	@00000100		;Shift
	jr	nz,got_modifier
	ld	hl,128
	ld	a,c
	and	@00000010		;Ctrl
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


