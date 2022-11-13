
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

.ide_wrblk
    ld a,(hl+)
    out (__IO_CF_IDE_DATA),a    ;write the data byte (hl++)
    ld a,(hl+)
    out (__IO_CF_IDE_DATA),a    ;write the data byte (hl++)
    djnz ide_wrblk              ;keep iterative count in b
    ret
