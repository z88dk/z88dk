;
; 	ANSI Video handling for the Robotron Z9001
;
;	Stefano Bodrato - Sept. 2016
;
;	Scrollup
;
;
;	$Id: f_ansi_scrollup.asm,v 1.1 2016-09-23 06:21:35 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_SCROLLUP

	EXTERN	__z9001_attr


.ansi_SCROLLUP
	push	de
	push	bc
	ld	hl,$EC00+40
	ld	de,$EC00
	ld	bc,40*23
	ldir
	ex	de,hl
	ld	b,40
scrollup_1:
	ld	(hl),32
	inc	hl
	djnz	scrollup_1

	ld	hl,$E800+40
	ld	de,$E800
	ld	bc,40*23
	ldir
	ex	de,hl
	ld	a,(__z9001_attr)
	ld	b,40
scrollup_2:
	ld	(hl),a
	inc	hl
	djnz	scrollup_2
	pop	bc
	pop	de
	ret
