;
;       MSX C Library
;
;       Fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fputc_cons.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB  fputc_cons

;
; Entry:        hl = points to char
;
.fputc_cons
	ld      hl,2
	add     hl,sp
	ld	a,(hl)

	cp	13
	jr	nz,nocrlf

	call	$a2
	ld	a,10

.nocrlf
	cp	12	; CLS ?
	jr	z,docls

	jp	$a2

.docls
	jp	$c3
