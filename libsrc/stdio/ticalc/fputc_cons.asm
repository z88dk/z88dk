;
;	TI calc Routines
;
;	fgetc_cons() Wait for keypress
;
;	Stefano Bodrato - Apr 2001
;
;
;	$Id: fputc_cons.asm,v 1.1 2001-04-20 11:56:39 stefano Exp $
;

	XLIB	fputc_cons

	INCLUDE	"stdio/ansi/ticalc/ticalc.inc"

.fputc_cons
	ld	hl,2
	add	hl,sp
	ld	a,(hl)

	cp	12		; CLS/FF
	jr	nz,nocls
	ld	b,8
.clsloop
	push	bc
	call	newline
	pop	bc
	djnz	clsloop

.nocls
	cp	13		;CR + auto LF
	jp	z,ti_newline

	cp	10		;NO LF
	ret	z


IF FORti83p
		rst	$28
		defw	ti_putchar
		ret
ELSE
	IF FORti85
		call	$8C09
		.defb	ti_putchar
		ret
	ELSE
		jp	ti_putchar
	ENDIF
ENDIF


.newline
IF FORti83p
		rst	$28
		defw	ti_newline
ELSE
	IF FORti85
		call	$8C09
		.defb	ti_newline
	ELSE
		call	ti_newline
	ENDIF
ENDIF
		ret