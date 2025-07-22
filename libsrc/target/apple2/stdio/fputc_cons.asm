;
;       CPM Library
;       Apple II version
;
;       Fputc_cons
;
;	Stefano Bodrato - 2025
;
;
;	$Id: fputc_cons.asm $
;

	SECTION	code_clib
	PUBLIC  fputc_cons_native
	EXTERN	__bdos
	EXTERN	a2_ctl
    EXTERN CLIB_FPUTC_CLS_CODE
    
	defc STANDARDESCAPECHARS=1

;
; Entry:        hl = points to char
;
.fputc_cons_native
	ld      hl,2
	add     hl,sp
	ld	d,0
	ld	a,(hl)
	ld	e,a
	cp	12	; FF (CLS) ?
	jr	z,docls
IF STANDARDESCAPECHARS
	cp	10	; LF ?
	jr	nz,nocrlf
	ld	de,13
	ld	c,2
	call	__bdos
	ld	de,10
ELSE
        cp      13      ; CR ?
        jr      nz,nocrlf
        ld      c,2
        call    __bdos
        ld      de,10
ENDIF
.nocrlf
	ld   c,2
	jp	 __bdos
.docls
	ld    l,1	; send the special character code for CLRHOME 
	jp    a2_ctl
