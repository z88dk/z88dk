;
;	S-OS (The Sentinel) Japanese OS - Stdio
;
;	(HL)=char to display
;
;----------------------------------------------------------------
;
;	$Id: fputc_cons.asm,v 1.2 2013-11-27 12:58:14 stefano Exp $
;
;----------------------------------------------------------------
;

	XLIB	fputc_cons

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
