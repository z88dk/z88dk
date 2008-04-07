;
;       TRS 80 C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: fgetc_cons.asm,v 1.1 2008-04-07 07:44:23 stefano Exp $
;


		XLIB	fgetc_cons

.fgetc_cons
        call    $2b
        ld      l,a
	ld	h,0
	ret

