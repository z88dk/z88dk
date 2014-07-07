;
;    Philips VG5000
;
;    getkey() Wait for keypress
;
;    Jun 2014 - Joaopa
;
;
;    $Id: getk.asm,v 1.1 2014-07-07 08:25:21 stefano Exp $
;
    XLIB    getk
.getk
	call	12983
	ld	l,a
	ld	h,0

	ret
