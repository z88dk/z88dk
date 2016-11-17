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
	EXTERN	bee_attr
	EXTERN	ansicolumns

.ansi_del_line
	ld	hl,$F000
.sum_loop
	ld	de,ansicolumns
	add	hl,de
	dec	a
	jr	nz,sum_loop
	push hl

	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,ansicolumns
	dec bc
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
	ld	bc,ansicolumns
	dec bc
	ldir
	xor a
	out (8),a

	ret

