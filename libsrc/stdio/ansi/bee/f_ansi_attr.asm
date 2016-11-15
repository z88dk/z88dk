;
; 	ANSI Video handling for the MicroBEE
;
; 	Text Attributes
;	m - Set Graphic Rendition
;	
;	The most difficult thing to port:
;	Be careful here...
;
;	Stefano Bodrato - 20161
;
;
;	$Id: f_ansi_attr.asm,v 1.1 2016-11-15 08:11:11 stefano Exp $
;

        SECTION  code_clib
	PUBLIC	ansi_attr

	PUBLIC	bee_attr
	

.ansi_attr
        ret

	SECTION  bss_clib
.bee_attr	defb 15
