;
;       MSX C Library
;
;       Fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fputc_cons.asm,v 1.6 2009-06-22 21:44:17 dom Exp $
;

	XLIB  fputc_cons
        LIB	msxbios


IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF


;
; Entry:        hl = points to char
;
.fputc_cons
	ld      hl,2
	add     hl,sp
	ld	a,(hl)

	ld	ix,CHPUT	; Print char

	cp	13
	jr	nz,nocrlf

	call	msxbios
	ld	a,10

.nocrlf
	cp	12	; CLS ?
	jr	nz,nocls
	ld	ix,CLS
.nocls
	jp	msxbios
