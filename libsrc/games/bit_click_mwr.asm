; $Id: bit_click_mwr.asm,v 1.2 2015-01-19 01:32:44 pauloscustodio Exp $
;
; 1 bit sound library - version for "memory write" I/O architectures
;
; void bit_click();
;
; Stefano Bodrato - 31/03/2008
;

    PUBLIC     bit_click
    INCLUDE  "games/games.inc"

    EXTERN     snd_tick

.bit_click
          ld   a,(snd_tick)
          xor  sndbit_mask
          ld   (sndbit_port),a
          ld   (snd_tick),a
          ret
