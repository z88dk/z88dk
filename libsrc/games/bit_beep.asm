; $Id: bit_beep.asm,v 1.3 2015-01-19 01:32:44 pauloscustodio Exp $
;
; 1 bit sound functions
;
; void bit_beep(int duration, int period);
;

    PUBLIC     bit_beep
    EXTERN      beeper

;
; Stub by Stefano Bodrato - 8/10/2001
;


.bit_beep
          pop bc
          pop hl
          pop de
          push de
          push hl
          push bc
          jp beeper
