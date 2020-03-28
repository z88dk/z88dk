; $Id: bit_open.asm $
;
; Sound support on the PC-G800 family with speaker mod
;
; void bit_open();
;
; Stefano Bodrato - 2019
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open
          xor	a
          ld   (__snd_tick),a
          ret
