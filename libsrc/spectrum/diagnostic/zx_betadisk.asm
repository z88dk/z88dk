;
;	ZX Spectrum specific routines
;
;	int zx_betadisk();
;
;	The result is:
;	- 0 (false) if the Beta 128 Disk Interface is missing
;	- 1 (true) if the Beta 128 Disk Interface is connected
;
;	It has the side effect of enabling the TRDOS System variables
;
;
;	$Id: zx_betadisk.asm,v 1.2 2015-01-19 01:33:07 pauloscustodio Exp $
;

	PUBLIC	zx_betadisk
	EXTERN	trdos_installed

zx_betadisk:

	ld	hl,16384
	ld	a,(hl)
	push	af
	ld	(hl),201	; ret instruction
	call	15619
	pop	af
	ld	(16384),a
	jp	trdos_installed
