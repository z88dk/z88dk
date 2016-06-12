;
; 	ANSI Video handling for the ZX81
;	By Stefano Bodrato - Sept. 2007
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.9 2016-06-12 16:06:43 dom Exp $
;

        SECTION code_clib
	PUBLIC	ansi_SCROLLUP
	EXTERN	ansi_del_line
	EXTERN	base_graphics
	EXTERN	text_rows


.ansi_SCROLLUP
	ld	hl,(base_graphics)
IF G007
	push hl
	ld	de,272
	add	hl,de
	pop de
ELSE
 IF MTHRG
	push hl
	ld	de,264
	add	hl,de
	pop de
 ELSE
	ld	d,h
	ld	e,l
	inc	h
 ENDIF
ENDIF

	ld	a,(text_rows)
	dec a

IF G007
	ld bc,272*23-1
ELSE
 IF MTHRG
	;ld bc,264*24-1
	ld  b,a		; *256
	add a
	add a
	add a		; *8   -> * 264
	ld	c,a
	ld	a,b	; keep A for ansi_del_line
 ELSE
	;ld	bc,6144-256
	ld	b,a
	ld	c,0
	;dec	b
 ENDIF
ENDIF
	ldir
;	ld	a,(text_rows)
;	dec	a
	call	ansi_del_line
	ret
