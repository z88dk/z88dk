;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.
;
;	Read 512 data bytes from SPI port $EB into the buffer at HL.
;	OUT clocks one byte. INI stores the byte that came back.
;	Z80N outinb writes (HL) and does not store the SPI byte.
;	HL ends 512 bytes higher. A is 0 and Z is set.
;

    PUBLIC  sd_read_sector_main

sd_read_sector_main:
    ld      c, $eb
    ld      b, 0
    ld      a, $ff
sd_zxn_rd1:
    out     (c), a
    ini
    jp      nz, sd_zxn_rd1
    ld      b, 0
sd_zxn_rd2:
    out     (c), a
    ini
    jp      nz, sd_zxn_rd2
    out     (c), a                      ; first CRC byte
    in      a, (c)
    ld      a, $ff
    out     (c), a                      ; second CRC byte
    in      a, (c)
    xor     a
    ret
