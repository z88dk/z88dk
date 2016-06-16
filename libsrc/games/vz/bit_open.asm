; $Id: bit_open.asm,v 1.3 2016-06-16 19:33:59 dom Exp $
;
; VZ 200 - 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 31/3/2008
;

    PUBLIC     bit_open
    EXTERN     __snd_tick

.bit_open
          ld    a,($783b)
          ld   (__snd_tick),a
          ret
