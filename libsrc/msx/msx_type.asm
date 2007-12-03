;
;	MSX specific routines
;	by Stefano Bodrato, 08/11/2007
;
;	int msx_type();
;
;	The int result is 1 or two, depending on the MSX hardware being used
;
;	$Id: msx_type.asm,v 1.2 2007-12-03 07:29:40 stefano Exp $
;

	XLIB	msx_type
	
msx_type:

	ld	a,($FAF8)		; running on MSX1?
	and	a
	ld	hl,1
	jr	z,is_msx1		; yes
	inc	l			; side effect: non zero FLAG if MSX2
is_msx1:
	ret
