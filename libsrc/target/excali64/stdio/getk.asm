;
;	Placeholder for reading a key from the keyboard
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

getk:
_getk:
	call	$0046
	;call	$0043		; console status ?
	ld	l,a
	ld	h,0
	ret
