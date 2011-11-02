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
;	$Id: hrg_tune_left.asm,v 1.1 2011-11-02 14:24:33 stefano Exp $
;

                XLIB	hrg_tune_left
				
				XREF	HRG_Handler

hrg_tune_left:
		ld	hl,HRG_Handler+1
		dec (hl)
		ret
