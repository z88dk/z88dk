
INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC ide_read_byte

    ;Do a read bus cycle to the drive, using the 8255.
    ;input A = ide register address
    ;output A = lower byte read from IDE drive
ide_read_byte:
    push bc
    push de
    ld d, a                 ;copy address to D
    ld bc, __IO_PIO_IDE_CTL
    out (c), a              ;drive address onto control lines
    or __IO_PIO_IDE_RD_LINE    
    out (c), a              ;and assert read pin
    ld bc, __IO_PIO_IDE_LSB
    in e, (c)               ;read the lower byte
    ld bc, __IO_PIO_IDE_CTL
    out (c), d              ;deassert read pin
    xor a
    out (c), a              ;deassert all control pins
    ld a, e
    pop de
    pop bc
    ret

