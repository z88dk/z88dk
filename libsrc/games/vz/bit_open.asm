; $Id: bit_open.asm,v 1.4 2016-06-16 20:23:52 dom Exp $
;
; VZ 200 - 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 31/3/2008
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC    _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open
          ld    a,($783b)
          ld   (__snd_tick),a
          ret
