;
; Sharp OZ family port (graphics routines)
; Stefano Bodrato - Aug 2002
;
;
;       Clear the graph. screen
;
;
;	$Id: clg.asm,v 1.1 2002-11-20 14:15:19 stefano Exp $
;


                XLIB    clg
		XREF	base_graphics

.clg
	        ld      hl,(base_graphics)
	        ld      (hl),l
	        ld      de,0a001h
	        ld      bc,2400-1
	        ldir
	
		ret
