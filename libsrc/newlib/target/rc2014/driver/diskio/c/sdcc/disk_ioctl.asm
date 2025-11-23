SECTION code_driver

PUBLIC _disk_ioctl

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

_disk_ioctl:

    pop af
    pop bc
    pop hl
    push hl
    push bc
    push af

    jp asm_disk_ioctl
