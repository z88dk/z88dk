;
;	S-OS (The Sentinel) Japanese OS - Stdio
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm,v 1.4 2016-05-15 20:15:46 dom Exp $
;
;----------------------------------------------------------------
;

	SECTION code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native

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
