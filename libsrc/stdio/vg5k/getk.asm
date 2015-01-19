;
;    Philips VG5000
;
;    getkey() Wait for keypress
;
;    Jun 2014 - Joaopa
;
;
;    $Id: getk.asm,v 1.3 2015-01-19 01:33:21 pauloscustodio Exp $
;
    PUBLIC    getk
	ld	ix,$47FA
.getk
	call	12983

	ld	l,a
	ld	h,0

	ret
