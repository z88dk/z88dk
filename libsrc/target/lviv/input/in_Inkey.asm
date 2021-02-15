; uint in_Inkey(void)
; 06.2018 suborb

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
	ld	hl,row_masks
	ld	c,0
	ld	b,@11111110
portD1:
	ld	a,b
	out	($D0),a
	in	a,($D1)
	cpl
	and	(hl)
	inc	hl
	jp	nz,gotkey
	ld	a,c
	add	8
	ld	c,a
	ld	a,b
	rlca
	ld	b,a
	jp	c,portD1
	; And now port D2
	ld	b,@11101110
portD2:
	ld	a,b
	out	($D2),a
	in	a,($D2)
	cpl
	and	(hl)
	inc	hl
	jp	nz,gotkey
	ld	a,c
	add	8
	ld	c,a
	ld	a,b
	rlca
	ld	b,a
	jp	c,portD2
nokey:
	ld	hl,0
	scf
	ret


gotkey:
	; c = offset, a = keypressed
hitkey_loop:
	rrca
	jr	c,doneinc
	inc	c
	jp	hitkey_loop
doneinc:
	;c = key offset

        ld      a,@11110111     ;Row 4
        out     ($d0),a
        in      a,($d1)
        cpl
        ld      d,a             ;Save the whole row
        and     @00001000
        ld      e,a             ;Right shift value keep
        ld      a,@01111111     ;Now, rows 7
        out     ($d0),a
        in      a,($d1)
        cpl
        and     @00000001
        or      e               ;So if nz, shift is pressed
	ld	hl,96
	jp	nz,got_modifier
	; Consider control now
        ;d holds row 3
        ;c holds shift status
        ld      a,d
        and     @00100000       ;Pick out right control
        ld      e,a             ;Save right control state
        ld      a,@10111111
        out     ($d0),a
        in      a,($d1)
        cpl
        and     @00000010       ;Pick out left control
        or      e               ;So if nz, control is pressed
	ld	hl,96*2
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





	SECTION rodata_clib

row_masks:
	defb	@11111111
	defb	@11111111
	defb	@11111111
	defb	@11010111	;RSHIFT, RCONTROL
	defb	@11111111
	defb	@11111100	;UN
	defb	@11111101	;LCTRL
	defb	@11111111
	defb	@11110000	;PortC
	defb	@11110000
	defb	@11110000
	defb	@11110000
