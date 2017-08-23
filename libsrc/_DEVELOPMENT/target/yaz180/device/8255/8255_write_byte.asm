
SECTION code_driver

PUBLIC ide_write_byte

EXTERN __IO_PIO_IDE_LSB, __IO_PIO_IDE_MSB, __IO_PIO_IDE_CTL, __IO_PIO_IDE_CONFIG
EXTERN __IO_PIO_IDE_RD, __IO_PIO_IDE_WR

EXTERN __IO_IDE_WR_LINE, __IO_IDE_RD_LINE, __IO_IDE_RST_LINE

    ;Do a write bus cycle to the drive, via the 8255
    ;input A = ide register address
    ;input E = lsb to write to IDE drive
    ;not preserved D (push / pop de in calling functions)
ide_write_byte:
    push bc
    ld d, a                 ;copy address to D
    ld bc, __IO_PIO_IDE_CONFIG
    ld a, __IO_PIO_IDE_WR
    out (c), a              ;config 8255 chip, write mode
    ld bc, __IO_PIO_IDE_CTL
    ld a, d    
    out (c), a              ;drive address onto control lines
    or __IO_IDE_WR_LINE    
    out (c), a              ;and assert write pin
    ld bc, __IO_PIO_IDE_LSB
    out (c), e              ;drive lower lines with lsb
    ld bc, __IO_PIO_IDE_CTL
    out (c), d              ;deassert write pin
    xor a
    out (c), a              ;deassert all control pins
    ld bc, __IO_PIO_IDE_CONFIG
    ld a, __IO_PIO_IDE_RD
    out (c), a              ;config 8255 chip, read mode
    pop bc
    ret

