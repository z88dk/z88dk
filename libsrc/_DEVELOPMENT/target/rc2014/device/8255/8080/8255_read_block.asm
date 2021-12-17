
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_read_block

    ;Read a block of 512 bytes (one sector) from the drive
    ;16 bit data register and store it in memory at (HL++)
    ;uses AF, BC, HL
.ide_read_block
    ld b,0                      ;keep iterative count in b

    ld a,__IO_IDE_DATA
    out (__IO_PIO_IDE_CTL),a    ;drive address onto control lines

.ide_rdblk
    ld a,__IO_IDE_DATA|__IO_IDE_RD_LINE
    out (__IO_PIO_IDE_CTL),a    ;and assert read pin
    in a,(__IO_PIO_IDE_LSB)     ;read the lower byte (HL++)
    ld (hl),a
    inc hl
    in a,(__IO_PIO_IDE_MSB)     ;read the upper byte (HL++)
    ld (hl),a
    inc hl
    ld a,__IO_IDE_DATA
    out (__IO_PIO_IDE_CTL),a    ;deassert read pin
    dec b                       ;keep iterative count in b
    jp NZ,ide_rdblk

    xor a
    out (__IO_PIO_IDE_CTL),a    ;deassert all control pins
    ret

