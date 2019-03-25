;
;   Version for the 2x3 graphics symbols
;
;   Load a 2x3 pseudo-graphics into the PCG bank
;   starting from character C up to character B-1
;

        SECTION code_graphics
	PUBLIC	loadudg6

	defc	PCG_RAM = $4000

.loadudg6
	in	a,($50)
	push	af
        res     1,a
        set     0,a
        out     ($70),a

	ld	c,0
	ld	b,64
	ld	hl, PCG_RAM + (256 * 16)
.loadudg6_1
	ld  d,c
	call setbyte
	call setbyte
	call setbyte
	inc	hl
	inc	hl
	inc	hl
	inc	hl
	ld   c,d
	inc  c
	ld   a,b
	cp   c
	jr	 nz,loadudg6_1
	pop	af
	out	($70),a
	ret


.setbyte
    call setbyte2
	rr c
	rr c
	ld	(hl),a
	inc hl
	ld	(hl),a
	inc hl
	ld	(hl),a
	inc hl
	ld	(hl),a
	inc hl
	ret
.setbyte2
	xor a
	bit 0,c
	jr	z,noright
	ld	a,$f0
.noright
	bit 1,c
	ret z
	add $0f
	ret
