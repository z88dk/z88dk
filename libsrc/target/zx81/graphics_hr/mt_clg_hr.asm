;--------------------------------------------------------------
; ZX81 HRG library for the Memotech expansion
; by Stefano Bodrato, Feb. 2010
;--------------------------------------------------------------
;
;   Set HRG mode and clear screen
;
;	$Id: mt_clg_hr.asm,v 1.6 2016-06-27 20:26:33 dom Exp $
;

	SECTION code_clib
	PUBLIC	_clg_hr
	PUBLIC	__clg_hr

	EXTERN		mt_hrg_on

	EXTERN	base_graphics

	defc _clg_hr = mt_hrg_on
	defc __clg_hr = mt_hrg_on
	
;	ld		hl,(base_graphics)
;IF FORzx81mt64
;	ld		c,64
;	jp	$249e		; CLEAR (64 rows only)
;ELSE
;	jp	$249c		; CLEAR
;ENDIF
