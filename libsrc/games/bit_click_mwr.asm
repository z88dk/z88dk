; $Id: bit_click_mwr.asm,v 1.1 2008-03-31 17:16:18 stefano Exp $
;
; 1 bit sound library - version for "memory write" I/O architectures
;
; void bit_click();
;
; Stefano Bodrato - 31/03/2008
;

    XLIB     bit_click
    INCLUDE  "games/games.inc"

    XREF     snd_tick

.bit_click
          ld   a,(snd_tick)
          xor  sndbit_mask
          ld   (sndbit_port),a
          ld   (snd_tick),a
          ret
