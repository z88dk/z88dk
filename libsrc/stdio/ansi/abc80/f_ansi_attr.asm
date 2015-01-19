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
;	$Id: f_ansi_attr.asm,v 1.3 2015-01-19 01:33:17 pauloscustodio Exp $
;

	PUBLIC	ansi_attr

.ansi_attr
        and     a
        jr      nz,noreset

        ret
.noreset
        ret
