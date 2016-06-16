; $Id: bit_open.asm,v 1.3 2016-06-16 19:33:59 dom Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 8/4/2008
;

    PUBLIC     bit_open
    EXTERN     __snd_tick

.bit_open
          ld   a,1
          ld   (__snd_tick),a
          ret
