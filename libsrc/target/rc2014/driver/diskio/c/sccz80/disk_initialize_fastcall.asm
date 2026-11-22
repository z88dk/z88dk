SECTION code_driver

PUBLIC disk_initialize

EXTERN asm_disk_initialize

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_initialize (BYTE pdrv) __smallc __z88dk_fastcall;
;

; initialize the ide drive

defc disk_initialize = asm_disk_initialize
