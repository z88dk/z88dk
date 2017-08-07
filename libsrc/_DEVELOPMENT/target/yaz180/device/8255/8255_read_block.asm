
SECTION code_driver

PUBLIC ide_read_block

EXTERN __IO_PIO_IDE_LSB, __IO_PIO_IDE_MSB, __IO_PIO_IDE_CTL, __IO_PIO_IDE_CONFIG
EXTERN __IO_PIO_IDE_RD, __IO_PIO_IDE_WR

EXTERN __IO_IDE_WR_LINE, __IO_IDE_RD_LINE, __IO_IDE_RST_LINE

EXTERN __IO_IDE_DATA, __IO_IDE_ERROR, __IO_IDE_SEC_CNT
EXTERN __IO_IDE_COMMAND, __IO_IDE_STATUS
EXTERN __IO_IDE_CONTROL, __IO_IDE_ALT_STATUS

    ;Read a block of 512 bytes (one sector) from the drive
    ;16 bit data register and store it in memory at (HL++)
ide_read_block:
    push bc
    push de
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA    
    out (c), d              ;drive address onto control lines
    ld e, $0                ;keep iterative count in e
ide_rdblk2:
    ld d, __IO_IDE_DATA|__IO_IDE_RD_LINE
    out (c), d              ;and assert read pin
    ld bc, __IO_PIO_IDE_LSB
    ini                     ;read the lower byte (HL++)
    ld bc, __IO_PIO_IDE_MSB
    ini                     ;read the upper byte (HL++)
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert read pin
    dec e                   ;keep iterative count in e
    jr nz, ide_rdblk2
   ;ld bc, __IO_PIO_IDE_CTL ;remembering what's in bc
    ld d, $0
    out (c), d              ;deassert all control pins
    pop de
    pop bc
    ret
