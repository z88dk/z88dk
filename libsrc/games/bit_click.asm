; $Id: bit_click.asm,v 1.2 2002-04-17 21:30:23 dom Exp $
;
; Generic 1 bit sound functions
;
; void bit_click();
;
; Stefano Bodrato - 2/10/2001
;

    XLIB     bit_click
    INCLUDE  "games/games.inc"

    XREF     snd_tick

.bit_click

          ld   a,(snd_tick)
          xor  sndbit_mask
          out  (sndbit_port),a
          ld   (snd_tick),a
          ret

