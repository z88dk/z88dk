;
;       MSX C Library
;
;       Fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fputc_cons.asm,v 1.5 2009-05-21 06:58:11 stefano Exp $
;

	XLIB  fputc_cons
        LIB	msxbios


IF FORmsx
        INCLUDE "#msxbios.def"
ELSE
        INCLUDE "#svibios.def"
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
