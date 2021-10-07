SECTION code_driver

PUBLIC disk_ioctl

EXTERN asm_disk_ioctl

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DRESULT disk_ioctl (BYTE pdrv, BYTE cmd, void* buff);
;

; entry
; c = BYTE pdrv
; b = BYTE cmd
; hl = void* buff
;
; exit
; l = DRESULT, set carry flag
    
; control the ide drive

disk_ioctl:

    pop af
    pop hl
    pop de
    pop bc
    push bc
    push de
    push hl
    push af
    
    ld b, e

    jp asm_disk_ioctl
