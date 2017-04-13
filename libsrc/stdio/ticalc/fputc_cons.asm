;
;	TI calc Routines
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - Apr 2001
;
;
;	$Id: fputc_cons.asm - 04/2017, Stefano $
;

	SECTION code_clib
	PUBLIC	fputc_cons_native

	INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

.fputc_cons_native
	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	cp	12		; CLS/FF
	jr	nz,nocls
	ld	b,8
.clsloop
	push	bc

IF FORti82
	call	$8D74
	defw	ti_scroll
ELSE
	call	scrollup
ENDIF

	pop	bc
	djnz	clsloop

IF FORti82
	; Nothing to do
ELSE
	ld	a,0
	ld	(ti_x_text),a
	ld	(ti_y_text),a
ENDIF
	ret


;  Linefeed or Carriage return ?

.nocls
IF STANDARDESCAPECHARS
	cp	10		;CR
	jr	z,docrlf
	cp	13
	jr	nz,nocrlf
ELSE
	cp	13		;CR
	jr	z,docrlf
	cp	10
	jr	nz,nocrlf
ENDIF
.docrlf

IF FORti82
	call	$8D74
	defw	ti_scroll
	ret
ELSE
	ld	a,0
	ld	(ti_x_text),a
	ld	a,(ti_y_text)
	cp	ti_maxy_t
	jr	z,scrollup
	inc	a
	ld	(ti_y_text),a
	ret
ENDIF

;  It's a char !
;  Check current position, do linefeed when necessary, and display it.

.nocrlf
IF FORti82
	call	$8D74
	defw	ti_putchar
	ret
ELSE
	push	af
	ld	a,(ti_x_text)
	cp	ti_maxx_t
	jr	nz,notlimit
	ld	a,(ti_y_text)
	cp	ti_maxy_t
	jr	nz,notlimit
	call	scrollup
	ld	a,0
	ld	(ti_x_text),a
.notlimit
	pop	af

	IF FORti83p
			rst	$28
			defw	ti_putchar
			ret
	ELSE
		IF FORti85
			call	$8C09
			defb	ti_putchar
			ret
		ELSE
			jp	ti_putchar
		ENDIF
	ENDIF
ENDIF


.scrollup
IF FORti82
	; Nothing here !!
ELSE
	IF FORti83p
			rst	$28
			defw	ti_scroll
			ret
	ELSE
		IF FORti85
			call	$8C09
			defb	ti_scroll
			ret
		ELSE
			jp	ti_scroll
		ENDIF
	ENDIF
ENDIF
