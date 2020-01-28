;
;	PacMan hardware
;
;	getk() Read key status
;
;	Feb 2017 - Stefano Bodrato
;
;
;	$Id:$
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

getk:
_getk:

	ld hl,0
	ret
