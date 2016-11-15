; $Id: bit_open.asm,v 1.1 2016-11-15 11:43:52 stefano Exp $
;
; Aussie Byte 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2016
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open
          ld   a,@01000000
          ld   (__snd_tick),a
          ret
