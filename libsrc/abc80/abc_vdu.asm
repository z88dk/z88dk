;
;	ABC80 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Set cursor shape
;
;	void abc_cursor(unsigned char shape);
;
;
;	$Id: abc_vdu.asm,v 1.1 2007-10-31 16:15:36 stefano Exp $
;	

XLIB	abc_cursor

abc_cursor:
	ld	a,11
	out	(56),a
	ld	a,l		; FASTCALL
	out	(57),a
	ret
