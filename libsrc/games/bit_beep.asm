; $Id: bit_beep.asm,v 1.1 2001-10-16 18:03:03 dom Exp $
;
; 1 bit sound functions
;
; void bit_beep(int duration, int period);
;

    XLIB     bit_beep
    LIB      beeper

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
