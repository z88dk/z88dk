SECTION code_driver

PUBLIC _disk_status

EXTERN asm_disk_status

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_status (BYTE pdrv);
;

; get the ide drive status

_disk_status:

    pop af
    pop hl
    push hl
    push af

    jp asm_disk_status
