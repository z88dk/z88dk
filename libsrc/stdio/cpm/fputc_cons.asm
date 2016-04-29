;
;       CPM Library
;
;       Fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fputc_cons.asm,v 1.8 2016-04-29 20:37:26 dom Exp $
;

	SECTION	code_clib
          PUBLIC  fputc_cons
          PUBLIC  _fputc_cons

;
; Entry:        hl = points to char
;
.fputc_cons
._fputc_cons
	ld      hl,2
	add     hl,sp
	ld	d,0
	ld	a,(hl)
	ld	e,a
	cp	12	; FF (CLS) ?
	jr	z,docls
IF STANDARDESCAPECHARS
	cp	10	; CR ?
	jr	nz,nocrlf
	ld	c,2
	call	5
	ld	de,13
ELSE
        cp      13      ; CR ?
        jr      nz,nocrlf
        ld      c,2
        call    5
        ld      de,10
ENDIF
.nocrlf
	ld      c,2
	jp	5
.docls
;	This is the ANSI CLS call
	ld	e,27
	ld	c,2
	call	5
	ld	e,'['
	ld	c,2
	call	5
	ld	e,'J'
	ld	c,2
	jp	5
