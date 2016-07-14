;
;	ABC80 specific routines
;	by Stefano Bodrato, Oct 2007
;
;	Set cursor shape
;
;	void abc_cursor(unsigned char shape);
;
;
;	$Id: abc_vdu.asm,v 1.2 2016-07-14 17:44:17 pauloscustodio Exp $
;	

PUBLIC	abc_cursor

abc_cursor:
	ld	a,11
	out	(56),a
	ld	a,l		; FASTCALL
	out	(57),a
	ret
