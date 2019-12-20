	INCLUDE	"graphics/grafix.inc"


        MODULE    smc777_getmaxx
        SECTION   code_clib
        PUBLIC    getmaxx
        PUBLIC    _getmaxx
	EXTERN	  __smc777_mode
	EXTERN	__console_w

.getmaxx
._getmaxx
	ld	a,(__smc777_mode)
	and	@00001100
	cp	@00001000	; 640
	ld	hl,639
	ret	z
	cp	@00000100	; 320
	ld	hl,319
	ret	z
	; We must be in lores mode here
	ld	a,(__console_w)
	add	a
	dec	a
	ld	l,a
	ld	h,0
	ret
