
SECTION code_driver

PUBLIC ide_write_byte

EXTERN PIO_IDE_LSB, PIO_IDE_MSB, PIO_IDE_CTL, PIO_IDE_CONFIG
EXTERN PIO_IDE_RD, PIO_IDE_WR

EXTERN IDE_WR_LINE, IDE_RD_LINE, IDE_RST_LINE

    ;Do a write bus cycle to the drive, via the 8255
    ;input A = ide register address
    ;input E = lsb to write to IDE drive
    ;uses DE
ide_write_byte:
    push bc
    ld d, a                 ;copy address to D (unused MSB)
    ld bc, PIO_IDE_CONFIG
    ld a, PIO_IDE_WR
    out (c), a              ;config 8255 chip, write mode
    ld bc, PIO_IDE_CTL
    ld a, d    
    out (c), a              ;drive address onto control lines
    or IDE_WR_LINE    
    out (c), a              ;and assert write pin
    ld bc, PIO_IDE_LSB
    out (c), e              ;drive lower lines with lsb
    ld bc, PIO_IDE_CTL
    out (c), d              ;deassert write pin
    xor a
    out (c), a              ;deassert all control pins
    ld bc, PIO_IDE_CONFIG
    ld a, PIO_IDE_RD
    out (c), a              ;config 8255 chip, read mode
    pop bc
    ret

