; $Id: beeper.asm,v 1.4 2016-06-16 20:23:52 dom Exp $
;
; SAM Coupe 1 bit sound functions
;
; Stefano Bodrato - 28/9/2001
;

    SECTION code_clib
    PUBLIC     beeper
    PUBLIC     _beeper



    EXTERN      bit_open_di
    EXTERN      bit_close_ei

.beeper
._beeper
     call    bit_open_di
	 call    $016F
	 di
	 call    bit_close_ei
	 ret
