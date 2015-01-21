;
;       Camputers Lynx C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - 2014
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-21 08:09:27 stefano Exp $
;


		PUBLIC	fgetc_cons

.fgetc_cons
        call    $9bd
		and     a
		jr      z,fgetc_cons
        ld      l,a
        ld      h,0
        ret

