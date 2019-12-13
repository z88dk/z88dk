
INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC ide_read_block

    ;Read a block of 512 bytes (one sector) from the drive
    ;16 bit data register and store it in memory at (HL++)
ide_read_block:
    push bc
    push de
    ld bc, __IO_PIO_IDE_CTL ;keep iterative count in b
    ld d, __IO_IDE_DATA    
    out (c), d              ;drive address onto control lines

IF (__IO_PIO_IDE_CTL = __IO_PIO_IDE_MSB+1) & (__IO_PIO_IDE_MSB = __IO_PIO_IDE_LSB+1)
ide_rdblk2:
    ld d, __IO_IDE_DATA|__IO_IDE_RD_LINE
    out (c), d              ;and assert read pin
    ld c, __IO_PIO_IDE_LSB  ;drive lower lines with lsb
    ini                     ;read the lower byte (HL++)
    inc c                   ;drive upper lines with msb
    ini                     ;read the upper byte (HL++)
    inc c                   ;drive control port
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert read pin
    djnz ide_rdblk2         ;keep iterative count in b

ELSE
ide_rdblk2:
    ld d, __IO_IDE_DATA|__IO_IDE_RD_LINE
    out (c), d              ;and assert read pin
    ld c, __IO_PIO_IDE_LSB  ;drive lower lines with lsb
    ini                     ;read the lower byte (HL++)
    ld c, __IO_PIO_IDE_MSB  ;drive upper lines with msb
    ini                     ;read the upper byte (HL++)
    ld c, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert read pin
    djnz ide_rdblk2         ;keep iterative count in b

ENDIF
;   ld c, __IO_PIO_IDE_CTL  ;remembering what's in c
    ld d, $0
    out (c), d              ;deassert all control pins
    pop de
    pop bc
    ret

