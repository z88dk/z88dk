; uint in_Inkey(void)

; Read current state of keyboard 

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

.in_Inkey
._in_Inkey
	ld	bc,64
	ld	hl,in_keytranstbl+64
loop:
	ld	a,b
	or	c
	jr	z,nokey
	dec	bc
	dec	hl
	ld	a,(hl)
	inc	a
	jr	z,loop
	in	a,(c)
	rrca
	jr	nc,loop


gotkey:
	; hl = offset in table to key
	; TODO: Check shift keys
	ld	bc,64
	in	a,(3)	;Shift key
	rrca
	jr	nc,noshift
	add	hl,bc
	jr	done
noshift:
	in	a,(7)	;Controlkey
	rrca
	jr	nc,done
	add	hl,bc
	add	hl,bc
done:

	ld	a,(hl)	
	cp	255
	jr	z,nokey
	ld	l,a
	ld	h,0
	and	a
	ret


nokey:
	ld	hl,0
	scf
	ret
