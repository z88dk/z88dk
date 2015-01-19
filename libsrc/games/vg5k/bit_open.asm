; $Id: bit_open.asm,v 1.2 2015-01-19 01:32:45 pauloscustodio Exp $
;
; VG-5000 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2014
;

    INCLUDE  "games/games.inc"

    PUBLIC     bit_open
    EXTERN     snd_tick

.bit_open
        ld a,8
        ld	(snd_tick),a
	  ret
