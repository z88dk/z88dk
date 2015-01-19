; $Id: bit_open.asm,v 1.2 2015-01-19 01:32:45 pauloscustodio Exp $
;
; TRS-80 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 8/4/2008
;

    PUBLIC     bit_open
    EXTERN     snd_tick

.bit_open
          ld   a,1
          ld   (snd_tick),a
          ret
