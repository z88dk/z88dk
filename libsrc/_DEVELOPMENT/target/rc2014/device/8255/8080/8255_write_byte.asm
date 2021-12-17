
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_write_byte

    ;Do a write bus cycle to the drive, via the 8255
    ;input A = ide register address
    ;input E = lsb to write to IDE drive
    ;uses AF, DE
.ide_write_byte
    ld d,a                      ;copy address to D

    ld a,__IO_PIO_IDE_WR
    out (__IO_PIO_IDE_CONFIG),a ;config 8255 chip, write mode
    ld a,d

    out (__IO_PIO_IDE_CTL),a    ;drive address onto control lines
    or __IO_IDE_WR_LINE
    out (__IO_PIO_IDE_CTL),a    ;and assert write pin
    ld a,e
    out (__IO_PIO_IDE_LSB),a    ;drive lower lines with lsb
    ld a,d
    out (__IO_PIO_IDE_CTL),a    ;deassert write pin
    xor a
    out (__IO_PIO_IDE_CTL),a    ;deassert all control pins

    ld a,__IO_PIO_IDE_RD
    out (__IO_PIO_IDE_CONFIG),a ;config 8255 chip, read mode
    ret

