;
;       Generic graphics routines
;	Self modifying code version
;
;       Stefano Bodrato - 4/1/2007
;
;
;       Reset pixel at (x,y) coordinate.
;
;
;	$Id: respixl_smc.asm,v 1.1 2007-01-04 17:41:34 stefano Exp $
;


		XLIB	respixel

		LIB	pixel
		XREF	pixmode

.respixel	push	hl
		ld	hl,0A62Fh	; CPL - AND (HL)
		ld	(pixmode),hl
		pop	hl
		jp	pixel
