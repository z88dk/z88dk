;
;       MSX C Library
;
;       Fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fputc_cons.asm,v 1.3 2007-12-03 07:29:40 stefano Exp $
;

	XLIB  fputc_cons
	LIB   msxbios

;
; Entry:        hl = points to char
;
.fputc_cons
	ld      hl,2
	add     hl,sp
	ld	a,(hl)

	ld	ix,$a2	; Print char

	cp	13
	jr	nz,nocrlf

	call	msxbios
	ld	a,10

.nocrlf
	cp	12	; CLS ?
	jr	nz,nocls
	ld	ix,$c3
.nocls
	jp	msxbios
