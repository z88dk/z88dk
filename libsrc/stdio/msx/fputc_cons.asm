;
;       MSX C Library
;
;       Fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fputc_cons.asm,v 1.8 2016-05-15 20:15:45 dom Exp $
;

	SECTION code_clib
	PUBLIC  fputc_cons_native
        EXTERN	msxbios


IF FORmsx
        INCLUDE "msxbios.def"
ELSE
        INCLUDE "svibios.def"
ENDIF


;
; Entry:        hl = points to char
;
.fputc_cons_native
	ld      hl,2
	add     hl,sp
	ld	a,(hl)

	ld	ix,CHPUT	; Print char
IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,nocrlf

	call	msxbios
IF STANDARDESCAPECHARS
	ld	a,13
ELSE
	ld	a,10
ENDIF

.nocrlf
	cp	12	; CLS ?
	jr	nz,nocls
	ld	ix,CLS
.nocls
	jp	msxbios
