;
;    Philips VG5000
;
;    getkey() Wait for keypress
;
;    Jun 2014 - Joaopa
;
;
;    $Id: getk.asm,v 1.2 2014-07-16 09:59:57 stefano Exp $
;
    XLIB    getk
	ld	ix,$47FA
.getk
	call	12983

	ld	l,a
	ld	h,0

	ret
