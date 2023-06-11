SECTION code_driver

PUBLIC disk_ioctl_callee

EXTERN asm_disk_ioctl

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DRESULT disk_ioctl (BYTE pdrv, BYTE cmd, void* buff) __z88dk_callee;
;

; entry
; c = BYTE pdrv
; b = BYTE cmd
; hl = void* buff
;
; exit
; l = DRESULT, set carry flag
    
; control the ide drive

disk_ioctl_callee:

    pop af
    pop hl
    pop de
    pop bc

    push af

    ld b, e

    jp asm_disk_ioctl
