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

    pop de                      ; pop return

    pop hl                      ; pop buffer
    pop bc                      ; pop cmd
    ld a,c
    pop bc                      ; pop pdrv
    ld b,a

    push de                     ; push return

    jp asm_disk_ioctl
