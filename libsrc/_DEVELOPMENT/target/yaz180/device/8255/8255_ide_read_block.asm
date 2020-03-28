
INCLUDE "config_private.inc"

SECTION code_driver

PUBLIC ide_read_block

    ;Read a block of 512 bytes (one sector) from the drive
    ;16 bit data register and store it in memory at (HL++)
ide_read_block:
    push bc
    push de
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA    
    out (c), d              ;drive address onto control lines
    ld e, $0                ;keep iterative count in e

IF (__IO_PIO_IDE_CTL = __IO_PIO_IDE_MSB+1) & (__IO_PIO_IDE_MSB = __IO_PIO_IDE_LSB+1)
ide_rdblk2:
    ld d, __IO_IDE_DATA|__IO_IDE_RD_LINE
    out (c), d              ;and assert read pin
    ld bc, __IO_PIO_IDE_LSB+$0200 ;drive lower lines with lsb, plus ini b offset
    ini                     ;read the lower byte (HL++)
    inc c                   ;drive upper lines with msb
    ini                     ;read the upper byte (HL++)
    inc c                   ;drive control port
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert read pin
    dec e                   ;keep iterative count in e
    jr NZ, ide_rdblk2

ELSE
ide_rdblk2:
    ld d, __IO_IDE_DATA|__IO_IDE_RD_LINE
    out (c), d              ;and assert read pin
    ld bc, __IO_PIO_IDE_LSB ;drive lower lines with lsb
    ini                     ;read the lower byte (HL++)
    ld bc, __IO_PIO_IDE_MSB ;drive upper lines with msb
    ini                     ;read the upper byte (HL++)
    ld bc, __IO_PIO_IDE_CTL
    ld d, __IO_IDE_DATA
    out (c), d              ;deassert read pin
    dec e                   ;keep iterative count in e
    jr NZ, ide_rdblk2

ENDIF
;   ld bc, __IO_PIO_IDE_CTL ;remembering what's in bc
;   ld e, $0
    out (c), e              ;deassert all control pins
    pop de
    pop bc
    ret

