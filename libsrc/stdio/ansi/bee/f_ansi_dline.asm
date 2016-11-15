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
;	$Id: f_ansi_dline.asm,v 1.1 2016-11-15 08:11:11 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_del_line
	EXTERN	bee_attr


.ansi_del_line
	ld	hl,$F000
.sum_loop
	ld	de,80
	add	hl,de
	dec	a
	jr	nz,sum_loop
	push hl

	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,79
	ldir
	
	ld	a,64
	out (8),a
	ld a,(bee_attr)
	pop hl
	ld de,$800
	add hl,de
	ld	(hl),a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,79
	ldir
	xor a
	out (8),a

	ret

