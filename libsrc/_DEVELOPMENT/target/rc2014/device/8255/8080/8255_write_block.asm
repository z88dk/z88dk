
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
    ld b,0                      ;keep iterative count in b

    ld a,__IO_PIO_IDE_WR
    out (__IO_PIO_IDE_CONFIG),a ;config 8255 chip, write mode

    ld a,__IO_IDE_DATA
    out (__IO_PIO_IDE_CTL),a    ;drive address onto control lines

.ide_wrblk
    ld a,__IO_IDE_DATA|__IO_IDE_WR_LINE
    out (__IO_PIO_IDE_CTL),a    ;and assert write pin
    ld a,(hl)
    inc hl
    out (__IO_PIO_IDE_LSB),a    ;write the lower byte (HL++)
    ld a,(hl)
    inc hl
    out (__IO_PIO_IDE_MSB),a    ;write the upper byte (HL++)
    ld a,__IO_IDE_DATA
    out (__IO_PIO_IDE_CTL),a    ;deassert write pin
    dec b                       ;keep iterative count in b
    jp NZ,ide_wrblk

    xor a
    out (__IO_PIO_IDE_CTL),a    ;deassert all control pins

    ld a,__IO_PIO_IDE_RD
    out (__IO_PIO_IDE_CONFIG),a ;config 8255 chip, read mode
    ret
