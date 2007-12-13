;
;	ZX Spectrum specific routines
;	by Stefano Bodrato, 14/09/2006
;
;	int zx_break();
;
;	Check if the CAPS-SPACE (BREAK) key is being pressed
;       ( 1 = pressed; 0 = not pressed )
;
;	$Id: zx_break.asm,v 1.1 2007-12-13 11:28:42 stefano Exp $
;

	XLIB	zx_break
	
zx_break:
	in	a,($fe)
	and	1
	xor	1
	ld	h,0
	ld	l,a
	ret
