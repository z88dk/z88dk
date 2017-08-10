SECTION code_driver

PUBLIC _disk_status_callee

EXTERN asm_disk_status

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_status (BYTE pdrv) __z88dk_callee;
;

; get the ide drive status

_disk_status_callee:

    pop af
    dec sp
    pop hl
    push af

    ld l,h

    jp asm_disk_status
