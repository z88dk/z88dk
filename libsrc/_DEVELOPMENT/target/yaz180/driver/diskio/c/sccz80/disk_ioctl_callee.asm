SECTION code_driver

PUBLIC _disk_ioctl_callee

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
; b = DRESULT, set carry flag
; hl = void* buff
    
; control the ide drive

_disk_ioctl_callee:

    pop af
    pop hl
    pop de
    pop bc

    push af
    
    ld b, c
    ld c, e

    jp asm_disk_ioctl
