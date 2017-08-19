SECTION code_driver

PUBLIC asm_disk_status

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_status (BYTE pdrv) __z88dk_fastcall;
;
;
; entry
; l = drive number, must be 0
;
; exit
; hl = DSTATUS, set carry flag
;

; get the ide drive status

asm_disk_status:
    push af
    xor a           ; clear a
    or l            ; check that that it is drive 0
    jr nz, sta_nodisk

    ld hl, 0        ; set DSTATUS OK
    pop af
    scf
    ret

sta_nodisk:
    ld hl, 2        ; set DSTATUS STA_NODISK
    pop af
    or a
    ret

