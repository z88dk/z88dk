;
;	ABC800 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Set cursor shape
;
;	void abc_cursor(unsigned char shape);
;
;
;	$Id: abc_cursor.asm,v 1.3 2016-06-10 22:55:52 dom Exp $
;	

	SECTION		code_clib
	PUBLIC	abc_cursor
	PUBLIC	_abc_cursor

abc_cursor:
_abc_cursor:
	ld	a,11
	out	(56),a
	ld	a,l		; FASTCALL
	out	(57),a
	ret
