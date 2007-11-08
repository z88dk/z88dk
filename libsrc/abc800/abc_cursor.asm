;
;	ABC800 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Set cursor shape
;
;	void abc_cursor(unsigned char shape);
;
;
;	$Id: abc_cursor.asm,v 1.1 2007-11-08 14:11:50 stefano Exp $
;	

XLIB	abc_cursor

abc_cursor:
	ld	a,11
	out	(56),a
	ld	a,l		; FASTCALL
	out	(57),a
	ret
