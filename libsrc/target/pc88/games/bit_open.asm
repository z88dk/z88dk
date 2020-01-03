; $Id: bit_open.asm $
;
; NEC PC-8801 - 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2018
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC    _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open
          ld    a,($E6C1)
          ld   (__snd_tick),a
          ret
