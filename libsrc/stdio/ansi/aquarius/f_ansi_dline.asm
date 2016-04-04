;
;
; 	ANSI Video handling for the Mattel Aquarius
;
;
; 	Clean a text line
;
;	Stefano Bodrato - Dec. 2001
;
; in:	A = text row number
;
;
;	$Id: f_ansi_dline.asm,v 1.3 2016-04-04 18:31:22 dom Exp $
;


        SECTION  code_clib
	PUBLIC	ansi_del_line
	EXTERN	aquarius_attr

.ansi_del_line
	ld	hl,$3000
	inc	a
.sum_loop
	ld	de,40
	add	hl,de
	dec	a
	jr	nz,sum_loop
	push	hl

	ld	(hl),32 ;' '
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,39
	ldir

	pop	hl
	ld	de,$400
	add	hl,de

	;ld	a,(aquarius_attr)
	ld	a,$70
	ld	(hl),a
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,39
	ldir
	
	ret
