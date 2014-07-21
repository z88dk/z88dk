;
;       Camputers Lynx C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2014
;
;
;	$Id: fgetc_cons.asm,v 1.1 2014-07-21 12:39:53 stefano Exp $
;


		XLIB	fgetc_cons

.fgetc_cons
        call    $9bd
		and     a
		jr      z,fgetc_cons
        ld      l,a
        ld      h,0
        ret

