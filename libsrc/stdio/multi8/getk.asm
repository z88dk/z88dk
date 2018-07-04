;
;	Placeholder for reading a key from the keyboard
;

        SECTION code_clib
	PUBLIC	getk
	PUBLIC	_getk

getk:
_getk:
	in	a,($00)		;Key code
	ld	l,a
	in	a,($01)		;Flags
				;bit 7 = shift
				;bit 6 = function key
				;bit 3 = not pressed/pressed
	bit	3,a
	jr	z,key_pressed
	ld	hl,0
	ret

key_pressed:
	; TODO: Take account of shift/function key etc
	ld	h,0
	ret
