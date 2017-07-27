
SECTION code_driver

PUBLIC ide_read_byte

EXTERN PIO_IDE_LSB, PIO_IDE_MSB, PIO_IDE_CTL, PIO_IDE_CONFIG
EXTERN PIO_IDE_RD, PIO_IDE_WR

EXTERN IDE_WR_LINE, IDE_RD_LINE, IDE_RST_LINE

    ;Do a read bus cycle to the drive, using the 8255.
    ;input A = ide register address
    ;output A = lower byte read from IDE drive
ide_read_byte:
    push bc
    push de
    ld d, a                 ;copy address to D
    ld bc, PIO_IDE_CTL
    out (c), a              ;drive address onto control lines
    or IDE_RD_LINE    
    out (c), a              ;and assert read pin
    ld bc, PIO_IDE_LSB
    in e, (c)               ;read the lower byte
    ld bc, PIO_IDE_CTL
    out (c), d              ;deassert read pin
    xor a
    out (c), a              ;deassert all control pins
    ld a, e
    pop de
    pop bc
    ret

