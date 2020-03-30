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
;	$Id: clg.asm $
;

                SECTION code_clib
                PUBLIC	clg
                PUBLIC	_clg
                EXTERN	_clg_hr

.clg
._clg
		jp	_clg_hr
