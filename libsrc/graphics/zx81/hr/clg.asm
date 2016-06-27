;--------------------------------------------------------------
; This code comes from the 'HRG_Tool' 
; by Matthias Swatosch
;--------------------------------------------------------------
;
;       Fast CLS for hi-rez ZX81
;
;       Stefano - Sept.2007
;	This version works on the first 64 lines only
;
;
;	$Id: clg.asm,v 1.4 2016-06-27 20:26:33 dom Exp $
;

                SECTION code_clib
                PUBLIC	clg
                PUBLIC	_clg
                EXTERN	_clg_hr

.clg
		jp	_clg_hr
