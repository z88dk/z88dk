;
;
; 	ANSI Video handling for the Alphatronic
;
;
; 	Clean a text line
;
;	Stefano Bodrato - 2022
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm $
;

        SECTION  code_clib
	PUBLIC	ansi_del_line
	EXTERN	__alphatro_attr
	EXTERN	__console_w
	EXTERN	generic_console_xypos


.ansi_del_line
	ld	b,a
	ld	c,0
	call	generic_console_xypos
	push	hl

	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,(__console_w)
	ld	b,0
	dec bc
	ldir
	
	ld a,(__alphatro_attr)
	pop hl
	set	3,h
	ld	(hl),a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,(__console_w)
	ld	b,0
	dec bc
	ldir

	ret

