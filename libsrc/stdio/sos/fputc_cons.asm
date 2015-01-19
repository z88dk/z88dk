;
;	S-OS (The Sentinel) Japanese OS - Stdio
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;
;----------------------------------------------------------------
;

	PUBLIC	fputc_cons

.fputc_cons

	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	cp	7		; bel
	jp	z,1FC4h

	cp	8
	jr	nz,nobs
	ld	a,$1d
.nobs
	jp	1FF4h 
