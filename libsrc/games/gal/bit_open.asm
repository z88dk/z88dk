; $Id: bit_open.asm,v 1.4 2016-06-16 19:33:59 dom Exp $
;
; Galaksija 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 8/4/2008
;

    PUBLIC     bit_open
    EXTERN     __snd_tick

.bit_open
          ld   a,@10111000
          ld   (__snd_tick),a
          ld   (8248),a
          ret
