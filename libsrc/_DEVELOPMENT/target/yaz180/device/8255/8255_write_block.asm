
SECTION code_driver

PUBLIC ide_write_block

EXTERN PIO_IDE_LSB, PIO_IDE_MSB, PIO_IDE_CTL, PIO_IDE_CONFIG
EXTERN PIO_IDE_RD, PIO_IDE_WR

EXTERN IDE_WR_LINE, IDE_RD_LINE, IDE_RST_LINE

EXTERN IDE_DATA, IDE_ERROR, IDE_SEC_CNT
EXTERN IDE_COMMAND, IDE_STATUS
EXTERN IDE_CONTROL, IDE_ALT_STATUS

    ;Write a block of 512 bytes (one sector) from (HL++) to
    ;the drive 16 bit data register
ide_write_block:
    push bc
    push de
    ld bc, PIO_IDE_CONFIG
    ld d, PIO_IDE_WR
    out (c), d              ;config 8255 chip, write mode
    ld bc, PIO_IDE_CTL
    ld d, IDE_DATA
    out (c), d              ;drive address onto control lines
    ld e, $0                ;keep iterative count in e
ide_wrblk2: 
    ld bc, PIO_IDE_CTL|IDE_WR_LINE
    out (c), d              ;and assert write pin
    ld bc, PIO_IDE_LSB      ;drive lower lines with lsb
    outi                    ;write the lower byte (HL++)
    ld bc, PIO_IDE_MSB      ;drive upper lines with msb
    outi                    ;write the upper byte (HL++)
    ld bc, PIO_IDE_CTL
    ld d, IDE_DATA
    out (c), d              ;deassert write pin
    dec e                   ;keep iterative count in e
    jr nz, ide_wrblk2
   ;ld bc, PIO_IDE_CTL      ;remembering what's in bc
    ld d, $0
    out (c), d              ;deassert all control pins
    ld bc, PIO_IDE_CONFIG
    ld d, PIO_IDE_RD
    out (c), d              ;config 8255 chip, read mode
    pop de
    pop bc
    ret
