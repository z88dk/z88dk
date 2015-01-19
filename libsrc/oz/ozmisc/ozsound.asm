;
;	Sharp OZ family functions
;
;	ported from the OZ-7xx SDK by by Alexander R. Pruss
;	by Stefano Bodrato - Oct. 2003
;
;
;	void ozsound(unsigned divisor);
;
; ------
; $Id: ozsound.asm,v 1.2 2015-01-19 01:33:02 pauloscustodio Exp $
;

	PUBLIC	ozsound

	EXTERN	ozinitsound

ozsound:
	call    ozinitsound
	xor     a					
	out     (16h),a  ; turn off note
	ld      hl,2
	add     hl,sp
	ld      a,(hl)
	out     (17h),a
	inc     hl
	ld      a,(hl)
	out     (18h),a
	ld      a,3
	out     (16h),a  ; set frequency and output tone
	ret
