; $Id: bit_click_mwr.asm,v 1.3 2016-04-23 21:06:32 dom Exp $
;
; 1 bit sound library - version for "memory write" I/O architectures
;
; void bit_click();
;
; Stefano Bodrato - 31/03/2008
;

    SECTION    code_clib
    PUBLIC     bit_click
    PUBLIC     _bit_click
    INCLUDE  "games/games.inc"

    EXTERN     snd_tick

.bit_click
._bit_click
          ld   a,(snd_tick)
          xor  sndbit_mask
          ld   (sndbit_port),a
          ld   (snd_tick),a
          ret
