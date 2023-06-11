
IF __CPU_INTEL__
INCLUDE "_DEVELOPMENT/target/rc2014/config_rc2014-8085_private.inc"
ELIF __CPU_Z80__
INCLUDE "config_private.inc"
ENDIF

SECTION code_driver

PUBLIC ide_drive_id

IF __IO_CF_8_BIT

EXTERN ide_wait_ready, ide_wait_drq

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; do the identify drive command, and return with the buffer 
; filled with info about the drive.
; uses AF, DE, HL
; the buffer to fill is in HL
; return carry on success

.ide_drive_id
    call ide_wait_ready

    ld a,11100000b              ;select the master device, LBA mode
    out (__IO_CF_IDE_HEAD),a
    call ide_wait_ready

    ld a,__IDE_CMD_ID
    out (__IO_CF_IDE_COMMAND),a
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

EXTERN ide_write_byte
EXTERN ide_read_block

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called by
; the main program.

; do the identify drive command, and return with the buffer 
; filled with info about the drive.
; uses AF, DE, HL
; the buffer to fill is in HL
; return carry on success

.ide_drive_id
    call ide_wait_ready

    ld de,__IO_PIO_IDE_HEAD<<8|11100000b
    call ide_write_byte         ;select the master device, LBA mode
    call ide_wait_ready

    ld de,__IO_PIO_IDE_COMMAND<<8|__IDE_CMD_ID
    call ide_write_byte         ;issue the command
    call ide_wait_ready         ;make sure drive is ready to proceed
    call ide_wait_drq           ;wait until it's got the data

    call ide_read_block         ;grab the data buffer in (HL++)

    scf                         ;carry = 1 on return = operation ok
    ret

ENDIF
