;
;       Sharp MZ C Library
;
;	Print character to the screen
;
;       We will corrupt any register
;
;
;	Sharp MZ Routines
;
;       Stefano Bodrato - 5/5/2000
;
;
;	$Id: fputc_cons.asm,v 1.3 2015-01-19 01:33:20 pauloscustodio Exp $
;


          PUBLIC  fputc_cons

;
; Entry:        hl points char to print
;

.savesp	defw	0

.fputc_cons

	ex	af,af'
	pop	af
	push	af

	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp	12	; Clear screen ?
	jr	nz,nocls
	;ld	a,$16
.nocls

	ld	(savesp),sp

	call	$12

	ld	sp,(savesp)

	ret