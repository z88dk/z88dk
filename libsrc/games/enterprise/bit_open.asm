; $Id: bit_open.asm,v 1.3 2015-01-19 01:32:44 pauloscustodio Exp $
;
; Enterprise 64/128 1 bit sound functions
;
; void bit_open();
;
; Stefano Bodrato - 2011
;

    PUBLIC     bit_open
    EXTERN     snd_tick

.bit_open

        ld      a,@00001000	; Set D/A mode on left channel
        out     ($A7),a
        ld  a,(snd_tick)

        ret
