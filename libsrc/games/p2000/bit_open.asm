; $Id: bit_open.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; Philips P2000 1 bit sound functions
;
; TRS-80 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - Apr 2014
;

    PUBLIC     bit_open
    EXTERN     snd_tick

.bit_open
          ld   a,1
          ld   (snd_tick),a
          ret
