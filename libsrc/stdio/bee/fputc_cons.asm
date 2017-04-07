;
;	MicroBEE Stdio
;
;	(HL)=char to output to console
;
;	Stefano Bodrato - 2016
;
;
;	$Id: fputc_cons.asm,v 1.1 2016-11-15 08:11:11 stefano Exp $
;


	SECTION code_clib
	PUBLIC	fputc_cons_native

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)
	cp  12
	jr  nz,nocls
	ld  a,$1a
.nocls
IF STANDARDESCAPECHARS
	cp  10
ELSE
	cp  13
ENDIF
	jr nz,nocr
.nocr


IF STANDARDESCAPECHARS
        cp      10      ; LF ?
        jr      nz,nocrlf
		ld  b,a
		call nocrlf
        ld      a,13
ELSE
		cp      13      ; CR ?
		jr      nz,nocrlf
		call nocrlf
		ld  a,10
ENDIF
.nocrlf
	ld  b,a
	jp	$800C
