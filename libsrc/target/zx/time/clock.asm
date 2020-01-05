;
;	clock()
;	Goodness knows it this is right..ages since
;	I used a spectrum...
;
;	djm 12/1/2000
;
; ------
; $Id: clock.asm,v 1.5 2016-06-10 21:14:50 dom Exp $
;

	SECTION code_clib
	PUBLIC	clock
	PUBLIC	_clock

  EXTERN  _FRAMES

.clock
._clock
	ld	hl,(_FRAMES)
	ld	a,(_FRAMES+2)
	ld	e,a
	ld	d,0
	ret
