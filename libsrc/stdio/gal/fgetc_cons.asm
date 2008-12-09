;
;       Galaksija C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: fgetc_cons.asm,v 1.1 2008-12-09 17:48:18 stefano Exp $
;


		XLIB	fgetc_cons

.fgetc_cons
        call    $cf5
        ld      l,a
	ld	h,0
	ret

