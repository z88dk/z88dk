
; Start one bit sound. The beeper is bit 5 of port $40, which can't be read,
; so the other bits (the printer strobe and the clock) are taken from
; N-BASIC's copy of the port.

    SECTION code_clib
    PUBLIC  bit_open
    PUBLIC  _bit_open
    EXTERN  __snd_tick

bit_open:
_bit_open:
    ld      a, ($ea67)
    ld      (__snd_tick), a
    ret
