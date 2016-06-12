;
;       Galaksija C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: fgetc_cons.asm,v 1.3 2016-06-12 17:00:21 dom Exp $
;


        SECTION code_clib
		PUBLIC	fgetc_cons

.fgetc_cons
        call    $cf5
        ld      l,a
	ld	h,0
	ret

