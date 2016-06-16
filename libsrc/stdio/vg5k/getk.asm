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

.getk
._getk
	call $aa

	ld	l,a
	ld	h,0

	ret
