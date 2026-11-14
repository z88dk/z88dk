;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Clock $FF on SPI data port $EB and return the byte in A.
;	BC, DE and HL stay as they were.
;

    PUBLIC  sd_get_byte

    EXTERN  sd_send_byte

sd_get_byte:
    ld      a, $ff
    jp      sd_send_byte
