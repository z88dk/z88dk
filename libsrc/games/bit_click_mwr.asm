; $Id: bit_click_mwr.asm,v 1.4 2016-06-11 20:52:25 dom Exp $
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

    EXTERN     __snd_tick

.bit_click
._bit_click
          ld   a,(__snd_tick)
          xor  sndbit_mask
          ld   (sndbit_port),a
          ld   (__snd_tick),a
          ret
