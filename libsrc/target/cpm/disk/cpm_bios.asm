; Copyright (c) November 2026 Phillip Stevens (feilipu)
;
; Call one CP/M 2.2 BIOS jump.
; The word at address 1 is the WBOOT jump. A is the byte offset from
; that jump. BC and DE reach the BIOS unchanged. The BIOS ret returns
; to the caller of cpm_bios. HL is whatever the BIOS left.

	SECTION	code_driver

	PUBLIC	cpm_bios

cpm_bios:
	push	bc
	push	de
	ld	hl,(1)
	ld	c,a
	ld	b,0
	add	hl,bc
	pop	de
	pop	bc
	jp	(hl)
