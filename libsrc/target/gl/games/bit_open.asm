
    SECTION code_clib
    PUBLIC  bit_open
    PUBLIC  _bit_open
    EXTERN  __snd_tick

    INCLUDE "games/games.inc"

.bit_open
._bit_open
	in	a,($12)
        ld      (__snd_tick),a
	ret
