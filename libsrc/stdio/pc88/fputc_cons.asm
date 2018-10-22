;
;	NEC PC8801 Library
;
;	Fputc_cons
;
;	Stefano Bodrato - 2018
;
;
;	$Id: fputc_cons.asm $
;

	SECTION code_clib
	PUBLIC  fputc_cons_native


        INCLUDE "target/pc88/def/n88bios.def"


;
; Entry:        hl = points to char
;
.fputc_cons_native
	ld      hl,2
	add     hl,sp
	ld	a,(hl)
	push	ix		;save callers

IF STANDARDESCAPECHARS
	cp	10
ELSE
	cp	13
ENDIF
	jr	nz,nocrlf

	call	OUTDO
IF STANDARDESCAPECHARS
	ld	a,13
ELSE
	ld	a,10
ENDIF

.nocrlf
	;cp	12	; CLS ?
	;jr	nz,nocls
	;	call	CLS
;.nocls
	call	OUTDO
	pop	ix		;restore callers
	ret
