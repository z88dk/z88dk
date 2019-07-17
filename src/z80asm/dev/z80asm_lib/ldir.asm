; Substitute for the z80 ldir instruction
; Doesn't emulate the flags correctly


SECTION code_crt0_sccz80
PUBLIC __z80asm__ldir

.__z80asm__ldir
	push	af
loop:
	ld	a,(hl)
	ld	(de),a
	inc	hl
	inc	de
	dec	bc
	ld	a,b
	or	c
	jp	nz,loop
	pop	af
	ret
