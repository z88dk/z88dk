;
;       Galaksija C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:20 pauloscustodio Exp $
;


		PUBLIC	fgetc_cons

.fgetc_cons
        call    $cf5
        ld      l,a
	ld	h,0
	ret

