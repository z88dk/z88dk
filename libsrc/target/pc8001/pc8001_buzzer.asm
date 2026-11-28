
; Switch the buzzer on or off. The buzzer sounds a tone of fixed pitch for as
; long as bit 5 of port $40 is set.
;
; Port $40 can't be read, so the other bits (the printer strobe and the
; calendar clock) are taken from N-BASIC's copy of it at $EA67, which is kept up
; to date as N-BASIC's own BEEP does.
;
; void pc8001_buzzer(int on) __z88dk_fastcall;

    SECTION code_clib
    PUBLIC  pc8001_buzzer
    PUBLIC  _pc8001_buzzer

pc8001_buzzer:
_pc8001_buzzer:
    ld      a, h
    or      l                           ;z if off
    ld      a, ($ea67)
    res     5, a
    jr      z, buzzer_off
    set     5, a
buzzer_off:
    ld      ($ea67), a
    out     ($40), a
    ret
