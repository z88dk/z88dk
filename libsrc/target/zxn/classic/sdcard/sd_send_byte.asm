;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	ZX Spectrum Next SPI data port $EB.
;	Send the byte in A and discard the byte that comes back.
;	BC, DE and HL stay as they were.
;

    PUBLIC  sd_send_byte

sd_send_byte:
    out     ($eb), a
    in      a, ($eb)
    ret
