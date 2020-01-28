;
;    Philips VG5000
;
;    getkey() Wait for keypress
;
;    Jun 2014 - Joaopa
;
;
;    $Id: getk.asm,v 1.5 2016-06-16 19:40:21 dom Exp $
;

        SECTION code_clib
	PUBLIC  getk
	PUBLIC  _getk

.getk
._getk
	push	iy
	ld	iy,$47FA		;iy -> ix
	call $aa
	pop	iy


IF STANDARDESCAPECHARS
	cp	13
	jr	nz,not_return
	ld	a,10
.not_return
ENDIF

	ld	l,a
	ld	h,0
	ret
