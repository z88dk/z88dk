; $Id: bit_beep.asm,v 1.2 2002-04-17 21:30:23 dom Exp $
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
