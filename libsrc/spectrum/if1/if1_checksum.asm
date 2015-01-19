;
;	ZX IF1 & Microdrive functions
;
;	if1_checksum (internal routine)
;
;	check BC bytes starting from HL 
;	and compare with the following byte
;
;	$Id: if1_checksum.asm,v 1.2 2015-01-19 01:33:10 pauloscustodio Exp $
;

	PUBLIC	if1_checksum
	
if1_checksum:
		push	hl
		ld	e,0
nxt_byte:
		ld	a,e
		add	(hl)
		inc	hl
		adc	1
		jr	z,noround
		dec	a
noround:	ld	e,a
		dec	bc
		ld	a,b
		or	c
		jr	nz,nxt_byte
		ld	a,e
		cp	(hl)
		pop	hl
		ret
