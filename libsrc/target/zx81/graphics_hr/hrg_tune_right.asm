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
;	$Id: hrg_tune_right.asm,v 1.3 2016-06-27 20:26:33 dom Exp $
;

		SECTION code_clib
                PUBLIC	hrg_tune_right
                PUBLIC	_hrg_tune_right
				
		EXTERN	HRG_Handler

hrg_tune_right:
_hrg_tune_right:
		ld	hl,HRG_Handler+1
		inc (hl)
		ret
