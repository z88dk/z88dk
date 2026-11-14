;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Deselect the bus. The Next core supplies card power.
;	AF stays as it was, including the flags.
;

    PUBLIC  sd_power_off

    EXTERN  sd_deselect_card
    EXTERN  sd_bytes_per_4ms

sd_power_off:
    call    sd_deselect_card
    push    hl
    ld      hl, 16384
    ld      (sd_bytes_per_4ms), hl
    pop     hl
    ret
