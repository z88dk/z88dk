;
;	Placeholder for reading a key from the keyboard
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

getk:
_getk:
	call	placeholder 	; ROM call to scan the keyboard
	ld	l,a
	ld	h,0
placeholder:
	ret

