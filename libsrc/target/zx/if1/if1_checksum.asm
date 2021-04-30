;
;	ZX IF1 & Microdrive functions
;
;	if1_checksum (internal routine)
;
;	check BC bytes starting from HL 
;	compare with the checksum stored in the following byte
;   update the checksum if it wrong
;
;	$Id: if1_checksum.asm $
;

	SECTION code_clib
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
		ld	(hl),a
		pop	hl
		ret
