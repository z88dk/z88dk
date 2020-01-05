;
;	clock()
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
