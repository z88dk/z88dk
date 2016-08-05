;
; 	ANSI Video handling for the Robotron Z1013
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - Aug 2016
;
;
;	$Id: f_ansi_attr.asm,v 1.1 2016-08-05 07:04:10 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_attr

	PUBLIC	z1013_inverse
	

.ansi_attr
        ret

	SECTION  bss_clib
.z1013_inverse	defb 0
