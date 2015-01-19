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
;	$Id: respixl_smc.asm,v 1.2 2015-01-19 01:32:46 pauloscustodio Exp $
;


		PUBLIC	respixel

		EXTERN	pixel
		EXTERN	pixmode

.respixel	push	hl
		ld	hl,0A62Fh	; CPL - AND (HL)
		ld	(pixmode),hl
		pop	hl
		jp	pixel
