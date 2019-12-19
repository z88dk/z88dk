; uint in_Inkey(void)
; 05.2018 suborb

; Read current state of keyboard but only return
; keypress if a single key is pressed.

SECTION code_clib
PUBLIC in_Inkey
PUBLIC _in_Inkey
EXTERN in_keytranstbl
EXTERN l_push_di
EXTERN l_pop_ei

; exit : carry set and HL = 0 for no keys registered
;        else HL = ASCII character code
; uses : AF,BC,DE,HL

.in_Inkey
._in_Inkey
	ld	hl,0
	ld	c,@01111111
	ld	b,4
	call	l_push_di
loop:
        ; Write line to port b of the ay
        ld      a,15
        out     ($00),a
        ld      a,c
        out     ($01),a
        ; And we want to read port a of the AY
        ld      a,14
        out     ($00),a
        in      a,($02)
	cpl
	and	@11111000
	jr	nz,gotkey
	ld	a,l
	add	8
	ld	l,a
	rrc	c
	djnz	loop
nokey:
	call	l_pop_ei
	ld	hl,0
	scf
	ret

gotkey:
	ex	af,af
	call	l_pop_ei
	ex	af,af
    ; a = key pressed
    ; l = offset
	ld	c,5
hitkey_loop:
	rlca
	jr	c,doneinc
	inc	l
	dec	c
	jr	nz,hitkey_loop
doneinc:
	ld	bc,in_keytranstbl
	add	hl,bc
	ld	a,(hl)
	cp	255
	jr	z, nokey
	ld	l,(hl)
	ld	h,0
	and	a
	ret


