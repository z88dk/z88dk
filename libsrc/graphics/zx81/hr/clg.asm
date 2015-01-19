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
;	$Id: clg.asm,v 1.3 2015-01-19 01:32:52 pauloscustodio Exp $
;

                PUBLIC	clg
                EXTERN	_clg_hr

.clg
		jp	_clg_hr