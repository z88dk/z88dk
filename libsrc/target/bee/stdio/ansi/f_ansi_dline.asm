;
;
; 	ANSI Video handling for the MicroBEE
;
;
; 	Clean a text line
;
;	Stefano Bodrato - 2016
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.2 2016-11-17 09:39:03 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_del_line
	EXTERN	__bee_attr
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
	
	ld	a,64
	out (8),a
	ld a,(__bee_attr)
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
	xor a
	out (8),a

	ret

