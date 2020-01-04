; $Id: bit_open.asm,v 1.5 2016-06-16 20:23:51 dom Exp $
;
; Galaksija 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 8/4/2008
;

    SECTION code_clib
    PUBLIC     bit_open
    PUBLIC     _bit_open
    EXTERN     __snd_tick

.bit_open
._bit_open
          ld   a,@10111000
          ld   (__snd_tick),a
          ld   (8248),a
          ret
