;
;	ABC800 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Set cursor shape
;
;	void abc_cursor(unsigned char shape);
;
;
;	$Id: abc_cursor.asm,v 1.2 2015-01-19 01:32:41 pauloscustodio Exp $
;	

PUBLIC	abc_cursor

abc_cursor:
	ld	a,11
	out	(56),a
	ld	a,l		; FASTCALL
	out	(57),a
	ret
