;--------------------------------------------------------------
; HRG screen effects
; for the ZX81
;--------------------------------------------------------------
;
;       Shift left the TV picture in hrg mode
;
;       Stefano - Oct 2011
;
;
;	$Id: hrg_tune_left.asm,v 1.2 2015-01-19 01:32:52 pauloscustodio Exp $
;

                PUBLIC	hrg_tune_left
				
				EXTERN	HRG_Handler

hrg_tune_left:
		ld	hl,HRG_Handler+1
		dec (hl)
		ret
