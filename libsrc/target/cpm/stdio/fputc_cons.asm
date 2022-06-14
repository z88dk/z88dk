;
;       CPM Library
;
;       Fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fputc_cons.asm,v 1.9 2016-05-15 20:15:45 dom Exp $
;

	SECTION	code_clib
	PUBLIC  fputc_cons_native
	EXTERN	__bdos
        EXTERN CLIB_CPM_NATIVE_VT100
        EXTERN CLIB_FPUTC_CLS_CODE
        

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
	ld      c,2
	jp	__bdos
.docls
        ld      a,CLIB_CPM_NATIVE_VT100
        and     a
        jr      nz,cls_ansi
        ld      a,CLIB_FPUTC_CLS_CODE
        jp      __bdos

cls_ansi:
;	This is the ANSI CLS call
	ld	e,27
	ld	c,2
	call	__bdos
	ld	e,'['
	ld	c,2
	call	__bdos
	ld	e,'J'
	ld	c,2
	jp	__bdos
