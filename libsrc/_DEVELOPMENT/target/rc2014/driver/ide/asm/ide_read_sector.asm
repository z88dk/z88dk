
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_read_sector

IF __IO_CF_8_BIT

EXTERN ide_wait_ready, ide_wait_drq
EXTERN ide_setup_lba

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; read a sector
; LBA specified by the 4 bytes in BCDE
; the address of the buffer to fill is in HL
; HL is left incremented by 512 bytes
; uses AF, BC, DE, HL
; return carry on success

.ide_read_sector
    call ide_wait_ready         ;make sure drive is ready
    call ide_setup_lba          ;tell it which sector we want in BCDE

    ld a,1
    out (__IO_CF_IDE_SEC_CNT),a ;set sector count to 1

    ld a,__IDE_CMD_READ
    out (__IO_CF_IDE_COMMAND),a ;ask the drive to read it

    call ide_wait_ready         ;make sure drive is ready to proceed
    call ide_wait_drq           ;wait until it's got the data

    ;Read a block of 512 bytes (one sector) from the drive
    ;16 bit data register and store it in memory at (HL++)

IF __CPU_INTEL__
    ld b,0                      ;keep iterative count in b
.ide_rdblk
    in a,(__IO_CF_IDE_DATA)     ;read the data byte (hl++)
    ld (hl+),a
    in a,(__IO_CF_IDE_DATA)     ;read the data byte (hl++)
    ld (hl+),a
    djnz ide_rdblk              ;keep iterative count in b

ELSE
    ld bc,__IO_CF_IDE_DATA&0xFF ;keep iterative count in b, I/O port in c
    inir
    inir

ENDIF
    scf                         ;carry = 1 on return = operation ok
    ret


ELSE

EXTERN ide_wait_ready, ide_wait_drq
EXTERN ide_setup_lba

EXTERN ide_write_byte, ide_write_byte_preset
EXTERN ide_read_block

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; read a sector
; LBA specified by the 4 bytes in BCDE
; the address of the buffer to fill is in HL
; HL is left incremented by 512 bytes
; uses AF, BC, DE, HL
; return carry on success

.ide_read_sector
    push de
    call ide_wait_ready         ;make sure drive is ready

    pop de
    call ide_setup_lba          ;tell it which sector we want in BCDE

    ld de,__IO_PIO_IDE_SEC_CNT<<8|1
    call ide_write_byte_preset  ;set sector count to 1

    ld de,__IO_PIO_IDE_COMMAND<<8|__IDE_CMD_READ
    call ide_write_byte_preset  ;ask the drive to read it

    call ide_wait_ready         ;make sure drive is ready to proceed
    call ide_wait_drq           ;wait until it's got the data

    call ide_read_block         ;grab the data into (HL++)

    scf                         ;carry = 1 on return = operation ok
    ret

ENDIF
