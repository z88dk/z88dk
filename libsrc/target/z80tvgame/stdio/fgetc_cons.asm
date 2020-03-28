;
;	Z80TVGame
;
;	getkey() Wait for keypress
;

        SECTION code_clib
	PUBLIC	fgetc_cons
	PUBLIC	_fgetc_cons

fgetc_cons:
_fgetc_cons:

	ld hl,0
	ret
