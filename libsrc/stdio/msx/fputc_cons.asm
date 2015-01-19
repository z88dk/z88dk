;
;       MSX C Library
;
;       Fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fputc_cons.asm,v 1.7 2015-01-19 01:33:20 pauloscustodio Exp $
;

	PUBLIC  fputc_cons
        EXTERN	msxbios


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
