
SECTION code_driver

PUBLIC ide_write_block

EXTERN __IO_PIO_IDE_LSB, __IO_PIO_IDE_MSB, __IO_PIO_IDE_CTL, __IO_PIO_IDE_CONFIG
EXTERN __IO_PIO_IDE_RD, __IO_PIO_IDE_WR

EXTERN __IO_IDE_WR_LINE, __IO_IDE_RD_LINE, __IO_IDE_RST_LINE

EXTERN __IO_IDE_DATA, __IO_IDE_ERROR, __IO_IDE_SEC_CNT
EXTERN __IO_IDE_COMMAND, __IO_IDE_STATUS
EXTERN __IO_IDE_CONTROL, __IO_IDE_ALT_STATUS

    ;Write a block of 512 bytes (one sector) from (HL++) to
    ;the drive 16 bit data register
ide_write_block:
    push bc
    push de
    ld bc, __IO_PIO_IDE_CONFIG
    ld d, __IO_PIO_IDE_WR
    out (c), d              ;config 8255 chip, write mode
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;drive address onto control lines
    ld e, $0                ;keep iterative count in e
ide_wrblk2: 
    ld bc, __IO_PIO_IDE_CTL|__IO_IDE_WR_LINE
    out (c), d              ;and assert write pin
    ld bc, __IO_PIO_IDE_LSB      ;drive lower lines with lsb
    outi                    ;write the lower byte (HL++)
    ld bc, __IO_PIO_IDE_MSB      ;drive upper lines with msb
    outi                    ;write the upper byte (HL++)
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert write pin
    dec e                   ;keep iterative count in e
    jr nz, ide_wrblk2
   ;ld bc, __IO_PIO_IDE_CTL      ;remembering what's in bc
    ld d, $0
    out (c), d              ;deassert all control pins
    ld bc, __IO_PIO_IDE_CONFIG
    ld d, __IO_PIO_IDE_RD
    out (c), d              ;config 8255 chip, read mode
    pop de
    pop bc
    ret
