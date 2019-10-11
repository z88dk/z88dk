;
;	Placeholder for reading a key from the keyboard
;
;	Yet the PV-1000 doesnt have a keybaord...
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

getk:
_getk:

	ld hl,0
	ret
