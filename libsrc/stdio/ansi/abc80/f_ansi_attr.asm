;
; 	ANSI Video handling for the ABC80
;	Leaving empty, for now.
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;
;	$Id: f_ansi_attr.asm,v 1.2 2001-04-13 14:13:59 stefano Exp $
;

	XLIB	ansi_attr

.ansi_attr
        and     a
        jr      nz,noreset

        ret
.noreset
        ret
