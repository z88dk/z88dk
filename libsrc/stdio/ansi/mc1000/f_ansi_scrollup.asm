;
; 	ANSI Video handling for the MC-1000
;
;	Scrollup
;
;	$Id: f_ansi_scrollup.asm $
;

	SECTION  code_driver
	
	PUBLIC	ansi_del_line
	PUBLIC	ansi_SCROLLUP


;-----------  GFX support for ANSI VT emulation  -------------
.ansi_SCROLLUP
	ld	a,$9e
	out	($80),a

	ld	de,$8000
	ld	hl,$8000+256
	ld	bc,6144-256
	ldir
	
	ld	a,23

.ansi_del_line
	ex	af,af
	ld	a,$9e
	out	($80),a
	ex	af,af

	ld	hl,$8000
	ld	d,a		; de = line*256
	ld	e,l
	add	hl,de	;Line address in HL	
	
	ld	bc,255
	ld	(hl),0
	ld	d,h
	ld	e,l
	inc	de
	ldir

	ld	a,$9f
	out	($80),a
	ret
