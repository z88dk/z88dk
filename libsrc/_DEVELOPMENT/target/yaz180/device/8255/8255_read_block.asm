
SECTION code_driver

PUBLIC ide_read_block

EXTERN PIO_IDE_LSB, PIO_IDE_MSB, PIO_IDE_CTL, PIO_IDE_CONFIG
EXTERN PIO_IDE_RD, PIO_IDE_WR

EXTERN IDE_WR_LINE, IDE_RD_LINE, IDE_RST_LINE

EXTERN IDE_DATA, IDE_ERROR, IDE_SEC_CNT
EXTERN IDE_COMMAND, IDE_STATUS
EXTERN IDE_CONTROL, IDE_ALT_STATUS

    ;Read a block of 512 bytes (one sector) from the drive
    ;16 bit data register and store it in memory at (HL++)
ide_read_block:
    push bc
    push de
    ld bc, PIO_IDE_CTL
    ld d, IDE_DATA    
    out (c), d              ;drive address onto control lines
    ld e, $0                ;keep iterative count in e
ide_rdblk2:
    ld d, IDE_DATA|IDE_RD_LINE
    out (c), d              ;and assert read pin
    ld bc, PIO_IDE_LSB
    ini                     ;read the lower byte (HL++)
    ld bc, PIO_IDE_MSB
    ini                     ;read the upper byte (HL++)
    ld bc, PIO_IDE_CTL
    ld d, IDE_DATA
    out (c), d              ;deassert read pin
    dec e                   ;keep iterative count in e
    jr nz, ide_rdblk2
   ;ld bc, PIO_IDE_CTL      ;remembering what's in bc
    ld d, $0
    out (c), d              ;deassert all control pins
    pop de
    pop bc
    ret
