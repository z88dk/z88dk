;   Videoton TV Computer ASM stub
;   Sandor Vass - 2022
;
;	Opens 1 bit (enable/disable - digital) sound channel for sound.h
;

    SECTION code_clib
    INCLUDE     "target/tvc/def/tvc.def"
    INCLUDE     "games/games.inc"
    PUBLIC      bit_open
    PUBLIC      _bit_open
    EXTERN      __snd_tick

.bit_open
._bit_open
    ld      a,(PORT05)      ; shuts off tone oscillator
    AND     @11101111
    ld      (PORT05),a      ; and that will not be turned on again on bit_close()...
    ld      a,(PORT06)      ; gets the current value of port 6 - from its mirror register
    AND     @11000011       ; ... and leave out the 4 volume bits
   	ld      (__snd_tick),a
	ret
