;--------------------------------------------------------------
; ZX81 HRG library for the Memotech expansion
; by Stefano Bodrato, Feb. 2010
;--------------------------------------------------------------
;
;   Set HRG mode and clear screen
;
;	$Id: mt_clg_hr.asm,v 1.4 2014-10-27 20:38:15 stefano Exp $
;

	XLIB	_clg_hr

	LIB		mt_hrg_on

	XREF	base_graphics

	
._clg_hr

	jp	mt_hrg_on
	
;	ld		hl,(base_graphics)
;IF FORzx81mt64
;	ld		c,64
;	jp	$249e		; CLEAR (64 rows only)
;ELSE
;	jp	$249c		; CLEAR
;ENDIF
