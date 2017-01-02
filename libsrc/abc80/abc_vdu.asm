;
;	ABC80 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Set cursor shape
;
;	void abc_cursor(unsigned char shape);
;
;
;	$Id: abc_vdu.asm,v 1.3 2017-01-02 19:42:41 aralbrec Exp $
;	

PUBLIC	abc_cursor
PUBLIC _abc_cursor

abc_cursor:
_abc_cursor:
	ld	a,11
	out	(56),a
	ld	a,l		; FASTCALL
	out	(57),a
	ret
