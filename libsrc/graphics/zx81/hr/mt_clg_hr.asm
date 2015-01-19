;--------------------------------------------------------------
; ZX81 HRG library for the Memotech expansion
; by Stefano Bodrato, Feb. 2010
;--------------------------------------------------------------
;
;   Set HRG mode and clear screen
;
;	$Id: mt_clg_hr.asm,v 1.5 2015-01-19 01:32:52 pauloscustodio Exp $
;

	PUBLIC	_clg_hr

	EXTERN		mt_hrg_on

	EXTERN	base_graphics

	
._clg_hr

	jp	mt_hrg_on
	
;	ld		hl,(base_graphics)
;IF FORzx81mt64
;	ld		c,64
;	jp	$249e		; CLEAR (64 rows only)
;ELSE
;	jp	$249c		; CLEAR
;ENDIF
