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
	SECTION bss_clib
	PUBLIC ti_usesmalltext
ti_usesmalltext: defb 0

	SECTION code_clib
	PUBLIC	fputc_cons_native

	INCLUDE	"target/ticalc/stdio/ansi/ticalc.inc"

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
	IF FORti83p
		ld a,(ti_usesmalltext)
		or a
		jr z,bigresetcursor
.smallresetcursor
	ld	a,0
	ld	(ti_x_text_small),a
	ld	(ti_y_text_small),a
	ret
.bigresetcursor
	ENDIF
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
	IF FORti83p
		ld a,(ti_usesmalltext)
		or a
		jr z,nosmallscroll
.smallscroll
		ld	a,0
		ld	(ti_x_text_small),a
		ld	a,(ti_y_text_small)
		cp	ti_maxy_t_small
		jr	z,scrollup
		add 6
		ld	(ti_y_text_small),a
		ret
.nosmallscroll
	ENDIF
	ld	a,0
	ld	(ti_x_text),a
	ld	a,(ti_y_text)
	cp	ti_maxy_t
	jr	z,scrollup
	inc a
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
	IF FORti83p
		ld a,(ti_usesmalltext)
		or a
		jr z,bigcharlimit
.smallcharlimit
		ld	a,(ti_x_text_small)
		cp	ti_maxx_t_small
		jr	c,notlimit
		; the cursor doesn't automatically reset
		ld	a,0
		ld	(ti_x_text_small),a
		ld	a,(ti_y_text_small)
		add 6
		ld (ti_y_text_small),a
		cp	ti_maxy_t_small
		jr	c,notlimit
		call	scrollup
		jr notlimit
.bigcharlimit
	ENDIF

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

	IF FORti83p
		ld a,(ti_usesmalltext)
		or a
		jr z,bigputchar
.smallputchar
		pop	af
		rst $28
		defw    ti_putchar_small
		ret
.bigputchar
		pop	af
		rst	$28
		defw	ti_putchar
		ret
	ELSE
		pop	af

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
