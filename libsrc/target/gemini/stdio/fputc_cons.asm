;
;	Gemini Galaxy Stdio
;
;	(HL)=char to output to console
;
;	Stefano Bodrato - 2022
;
;
;	$Id: fputc_cons.asm $
;


	SECTION code_clib
	PUBLIC	fputc_cons_native

	EXTERN putvid_a

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

	jp putvid_a
