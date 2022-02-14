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

;
; Entry:        hl = points to char
;
.fputc_cons_native
	ld      hl,2
	add     hl,sp
	ld	d,0
	ld	a,(hl)
	ld	e,a
IF STANDARDESCAPECHARS
	cp	10	; LF ?
	jr	nz,nocrlf
	ld	de,13
	ld	c,2
	call	5
	ld	de,10
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
