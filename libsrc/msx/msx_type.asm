;
;	MSX specific routines
;	by Stefano Bodrato, 08/11/2007
;
;	int msx_type();
;
;	The int result is 1 or two, depending on the MSX hardware being used
;
;	$Id: msx_type.asm,v 1.3 2009-05-21 06:58:11 stefano Exp $
;

	XLIB	msx_type
	
msx_type:

	ld	a,($FAF8)		; running on MSX1?
	and	a
	ld	hl,1
	ret	z			; yes

	ld	h,3
	ld	a,($7d63)		; BASIC SubVersion string
	sub	45
	ld	l,a
	ret	z			; 3 = SVI-318
	
	ld	a,($7db0)
	cp	$5d
	ret	z			; 4 = SVI-328
	
	inc	l			; 5 = SVI-328 MKII
	cp	$3e
	ret	z
	
	ld	l,2
	ret				; 2 = MSX2 (zero flag is reset)
