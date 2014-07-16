; $Id: bit_open.asm,v 1.1 2014-07-16 09:59:57 stefano Exp $
;
; VG-5000 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2014
;

    INCLUDE  "games/games.inc"

    XLIB     bit_open
    XREF     snd_tick

.bit_open
        ld a,8
        ld	(snd_tick),a
	  ret
