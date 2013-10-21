; $Id: bit_open.asm,v 1.1 2013-10-21 14:23:45 stefano Exp $
;
; Generic 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2001..2013
;

    INCLUDE  "games/games.inc"

    XLIB     bit_open
    XREF     snd_tick

.bit_open
	  ld a,(snd_tick)
	  ret
