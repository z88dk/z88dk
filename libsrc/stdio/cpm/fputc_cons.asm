;
;       CPM Library
;
;       Fputc_cons
;
;	Stefano Bodrato - Apr. 2000
;
;
;	$Id: fputc_cons.asm,v 1.7 2016-03-31 13:50:49 dom Exp $
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
	cp	10	; CR ?
	jr	nz,nocrlf
	ld	c,2
	call	5
	ld	de,13
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
