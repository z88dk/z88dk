;
;	MSX specific routines
;	by Stefano Bodrato, 29/11/2007
;
;	int msx_color(int foreground, int background, int border );
;
;	Change the MSX color attributes
;
;	$Id: msx_color.asm,v 1.1 2007-12-03 07:29:39 stefano Exp $
;

	XLIB	msx_color
	LIB	msxbios
	
msx_color:

	ld	ix,0
	add	ix,sp
	ld	a,(ix+2)	;border
	ld	(0F3EBh),a
	ld	a,(ix+4)	;background
	ld	(0F3EAh),a
	ld	a,(ix+6)	;foreground
	ld	(0F3E9h),a
	ld	a,(0FCAFh)	;SCRMOD
	ld	ix,0062h	;CHGCLR
	jp	msxbios
