SECTION code_driver

PUBLIC asm_disk_initialize

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
; hl = DSTATUS, set carry flag
;


; initialize the ide drive

.asm_disk_initialize
    xor a                       ; clear a
    or l                        ; check that that it is drive 0
    jr NZ,sta_nodisk

    call ide_hard_reset         ; hard reset the drive
    jr NC,sta_noinit

    call ide_soft_reset         ; soft reset the drive
    jr NC,sta_noinit

    call ide_init               ; initialize the drive. If there is no drive, this may hang
    jr NC,sta_noinit

    ld hl,0                     ; set DSTATUS OK
    scf
    ret

.sta_noinit
    ld hl,1                     ; set DSTATUS STA_NOINIT
    ret

.sta_nodisk
    ld hl,2                     ; set DSTATUS STA_NODISK
    ret

