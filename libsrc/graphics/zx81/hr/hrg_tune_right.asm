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
;	$Id: hrg_tune_right.asm,v 1.1 2011-11-02 14:24:33 stefano Exp $
;

                XLIB	hrg_tune_right
				
				XREF	HRG_Handler

hrg_tune_right:
		ld	hl,HRG_Handler+1
		inc (hl)
		ret
