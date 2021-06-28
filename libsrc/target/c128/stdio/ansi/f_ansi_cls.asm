;
; 	ANSI Video handling for the Commodore 128 (Z80 mode)
;	By Stefano Bodrato - 22/08/2001
;
; 	CLS - Clear the screen
;	
;
;	$Id: f_ansi_cls.asm $
;

	SECTION code_clib
	PUBLIC	ansi_cls

	EXTERN		__c128_paper

.ansi_cls
	ld	hl,$2000	; Text
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,1023
	ld	(hl),32
	ldir
	ld	hl,$1000	; Color attributes
	ld	d,h
	ld	e,l
	inc	de
	ld	bc,1023
	ld	(hl),1
	ldir
	ld	bc,$D021
	ld	a,(__c128_paper)
	out (c),a
	ld	bc,$D020	; BORDER
	out (c),a
	ret
