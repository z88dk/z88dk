;
;	PacMan hardware
;
;	getkey() Wait for keypress
;
;	Feb 2017 - Stefano Bodrato
;
;
;	$Id:$
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

fgetc_cons:
_fgetc_cons:

	ld hl,0
	ret
