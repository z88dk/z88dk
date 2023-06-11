; uint in_Inkey(void)
; 02.2022 suborb

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
	ld	c,0
	ld	b,1
port_loop:
	ld	a,b
	out	($82),a
	in	a,($81)
	cpl
	jp	nz,gotkey
	ld	a,c
	add	8
	ld	c,a
	inc	b
	ld	a,b
	cp 	10
	jp	nz,port_loop
nokey:
	ld	hl,0
	scf
	ret


gotkey:
	; c = offset, a = keypressed
hitkey_loop:
	rrca
	jp	c,doneinc
	inc	c
	jp	hitkey_loop
doneinc:
	;c = key offset
	;check for modifiers

	ld	a,6
	out	($82),a
	in	a,($81)
	cpl
        ld      d,a             ;Save the whole row
        and     @00000001
	ld	hl,80
	jp	nz,got_modifier
	ld	a,d
	and	@00000010
	ld	hl,160
	jp	nz,got_modifier
	ld	hl,0
got_modifier:
	ld	de,in_keytranstbl
	add	hl,de
	ld	b,0
	add	hl,bc
	ld	a,(hl)
	cp	255
	jp	z,nokey
	ld	l,a
	ld	h,0
	and	a
	ret



