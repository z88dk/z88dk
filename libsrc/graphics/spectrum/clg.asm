;
;       Lite CLS for the Speccy
;	
;
;
;	$Id: clg.asm,v 1.1 2002-02-27 13:12:26 stefano Exp $
;


                XLIB    clg
		XREF	base_graphics

.clg
		ld	hl,16384	; base of graphics area
		ld	(hl),0
		ld	de,16385	; de = base_graphics+1
		ld	bc,6143
		ldir
		ret