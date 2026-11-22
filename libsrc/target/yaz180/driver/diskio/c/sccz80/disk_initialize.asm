SECTION code_driver

PUBLIC disk_initialize

EXTERN asm_disk_initialize

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_initialize (BYTE pdrv);
;

; initialize the ide drive

disk_initialize:

    pop af
    pop hl
    push hl
    push af

    jp asm_disk_initialize
