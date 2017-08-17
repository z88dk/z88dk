SECTION code_driver

PUBLIC _disk_initialise_callee

EXTERN asm_disk_initialise

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_initialize (BYTE pdrv) __z88dk_callee;
;

; initialize the ide drive

_disk_initialise_callee:

    pop af
    pop hl
    push af

    jp asm_disk_initialise
