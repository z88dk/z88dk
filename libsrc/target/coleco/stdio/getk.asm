;
;	Placeholder for reading a key from the keyboard
;
;	Yet the Colecovision doesnt have a keybaord...
;
;	TODO: Something with the number pad
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

getk:
_getk:

	ld hl,0
	ret
