
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

.ide_rdblk
    in a,(__IO_CF_IDE_DATA)     ;read the data byte (hl++)
    ld (hl+),a
    in a,(__IO_CF_IDE_DATA)     ;read the data byte (hl++)
    ld (hl+),a
    djnz ide_rdblk              ;keep iterative count in b
    ret

