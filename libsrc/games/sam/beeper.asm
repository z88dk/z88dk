; $Id: beeper.asm,v 1.2 2013-10-21 14:23:45 stefano Exp $
;
; SAM Coupe 1 bit sound functions
;
; Stefano Bodrato - 28/9/2001
;

    XLIB     beeper



    LIB      bit_open_di
    LIB      bit_close_ei

.beeper
     call    bit_open_di
	 call    $016F
	 di
	 call    bit_close_ei
	 ret
