; $Id: beeper.asm,v 1.3 2015-01-19 01:32:45 pauloscustodio Exp $
;
; SAM Coupe 1 bit sound functions
;
; Stefano Bodrato - 28/9/2001
;

    PUBLIC     beeper



    EXTERN      bit_open_di
    EXTERN      bit_close_ei

.beeper
     call    bit_open_di
	 call    $016F
	 di
	 call    bit_close_ei
	 ret
