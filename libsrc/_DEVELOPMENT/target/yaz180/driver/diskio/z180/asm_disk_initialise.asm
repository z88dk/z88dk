SECTION code_driver

PUBLIC asm_disk_initialise

EXTERN ide_hard_reset
EXTERN ide_soft_reset
EXTERN ide_init

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_initialize (BYTE pdrv) __z88dk_fastcall;
;
; entry
; l = drive number, must be 0
;
; exit
; l = DSTATUS, set carry flag


; initialize the ide drive

asm_disk_initialise:
    push af
    xor a       ; clear a
    or l        ; check that that it is drive 0
    jr nz, sta_nodisk

    ; hard reset the drive
    call ide_hard_reset

    ; soft reset the drive
    call ide_soft_reset
    jr nc, sta_noinit

    ;initialize the drive. If there is no drive, this may hang
    call ide_init
    jr nc, sta_noinit

    ld l, 0             ; set DSTATUS OK
    pop af
    scf                 
    ret

sta_noinit:
    ld l, 1             ; set DSTATUS STA_NOINIT
    pop af
    ccf
    ret

sta_nodisk:
    ld l, 2             ; set DSTATUS STA_NODISK
    pop af
    ccf
    ret

