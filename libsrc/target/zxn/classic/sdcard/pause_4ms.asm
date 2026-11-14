;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Wait about 4 ms at 28 MHz. Slower clocks wait longer.
;	BC, DE and HL stay as they were. AF may change.
;

    PUBLIC  pause_4ms

pause_4ms:
    push    bc
    push    de
    push    hl
    ld      hl, 5000
sd_zxn_wait:
    dec     hl
    ld      a, h
    or      l
    jr      nz, sd_zxn_wait
    pop     hl
    pop     de
    pop     bc
    ret
