; $Id: bit_open.asm,v 1.3 2015-01-19 01:32:44 pauloscustodio Exp $
;
; Galaksija 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 8/4/2008
;

    PUBLIC     bit_open
    EXTERN     snd_tick

.bit_open
          ld   a,@10111000
          ld   (snd_tick),a
          ld   (8248),a
          ret
