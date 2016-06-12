;
;       Galaksija C Library
;
;	getkey() Wait for keypress
;
;	Stefano Bodrato - Apr. 2008
;
;
;	$Id: fgetc_cons.asm,v 1.4 2016-06-12 17:07:44 dom Exp $
;


        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

.fgetc_cons
._fgetc_cons
        call    $cf5
        ld      l,a
	ld	h,0
	ret

