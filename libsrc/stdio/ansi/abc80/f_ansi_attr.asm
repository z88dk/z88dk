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

	XLIB	ansi_attr

.ansi_attr
        and     a
        jr      nz,noreset

        ret
.noreset
        ret
