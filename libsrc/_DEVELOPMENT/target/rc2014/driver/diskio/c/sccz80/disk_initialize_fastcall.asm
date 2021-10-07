SECTION code_driver

PUBLIC disk_initialize_fastcall

EXTERN asm_disk_initialize

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_initialize (BYTE pdrv) __z88dk_fastcall;
;

; initialize the ide drive

defc disk_initialize_fastcall = asm_disk_initialize
