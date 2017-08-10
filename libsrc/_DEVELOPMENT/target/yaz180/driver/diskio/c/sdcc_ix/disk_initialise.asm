SECTION code_driver

PUBLIC _disk_initialise

EXTERN asm_disk_initialise

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_initialize (BYTE pdrv);
;

; initialize the ide drive

_disk_initialise:

    pop af
    pop hl
    push hl
    push af

    jp asm_disk_initialise
