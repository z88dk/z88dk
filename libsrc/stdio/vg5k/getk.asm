;
;    Philips VG5000
;
;    getkey() Wait for keypress
;
;    Jun 2014 - Joaopa
;
;
;    $Id: getk.asm,v 1.4 2015-10-08 17:12:22 stefano Exp $
;
    PUBLIC    getk
	ld	ix,$47FA
.getk
	call $aa

	ld	l,a
	ld	h,0

	ret
