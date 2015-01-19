;
;       TRS 80 C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: fgetc_cons.asm,v 1.2 2015-01-19 01:33:21 pauloscustodio Exp $
;


		PUBLIC	fgetc_cons

.fgetc_cons
        call    $2b
        ld      l,a
	ld	h,0
	ret

