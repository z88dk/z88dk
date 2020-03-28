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
;	$Id: f_ansi_attr.asm,v 1.4 2016-06-12 16:06:42 dom Exp $
;

	SECTION code_clib
	PUBLIC	ansi_attr

.ansi_attr
        and     a
        jr      nz,noreset

        ret
.noreset
        ret
