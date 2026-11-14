;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Write 512 data bytes from HL to SPI port $EB.
;	Each OUT is followed by IN, as sd_send_byte does.
;	HL ends 512 bytes higher. Two $FF CRC clocks follow.
;

    PUBLIC  sd_write_sector_main

    EXTERN  sd_send_eight_clocks

sd_write_sector_main:
    ld      b, 0
sd_zxn_wr:
    ld      a, (hl)
    inc     hl
    out     ($eb), a
    in      a, ($eb)
    ld      a, (hl)
    inc     hl
    out     ($eb), a
    in      a, ($eb)
    djnz    sd_zxn_wr
    call    sd_send_eight_clocks
    jp      sd_send_eight_clocks
