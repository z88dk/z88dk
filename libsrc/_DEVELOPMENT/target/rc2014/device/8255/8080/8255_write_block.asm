
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_write_block

    ;Write a block of 512 bytes (one sector) from (HL++) to
    ;the drive 16 bit data register
    ;uses AF, BC, HL

.ide_write_block
    ld a,__IO_PIO_IDE_WR
    out (__IO_PIO_IDE_CONFIG),a ;config 8255 chip, write mode
    ld a,__IO_PIO_IDE_DATA
    out (__IO_PIO_IDE_CTL),a    ;drive address onto control lines
    ld b,0                      ;keep iterative count in b

.ide_wrblk
    ld a,__IO_PIO_IDE_DATA|__IO_PIO_IDE_WR_LINE
    out (__IO_PIO_IDE_CTL),a    ;and assert write pin
    ld a,(hl+)
    out (__IO_PIO_IDE_LSB),a    ;write the lower byte (HL++)
    ld a,(hl+)
    out (__IO_PIO_IDE_MSB),a    ;write the upper byte (HL++)
    ld a,__IO_PIO_IDE_DATA
    out (__IO_PIO_IDE_CTL),a    ;deassert write pin
    djnz ide_wrblk              ;keep iterative count in b

    xor a
    out (__IO_PIO_IDE_CTL),a    ;deassert all control pins
    ret
