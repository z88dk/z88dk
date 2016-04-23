; $Id: bit_beep.asm,v 1.4 2016-04-23 21:06:32 dom Exp $
;
; 1 bit sound functions
;
; void bit_beep(int duration, int period);
;
    SECTION    code_clib
    PUBLIC     bit_beep
    PUBLIC     _bit_beep
    EXTERN      beeper

;
; Stub by Stefano Bodrato - 8/10/2001
;


.bit_beep
._bit_beep
          pop bc
          pop hl
          pop de
          push de
          push hl
          push bc
          jp beeper
