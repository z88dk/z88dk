SECTION code_driver

PUBLIC _disk_initialise_fastcall

EXTERN asm_disk_initialise

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DSTATUS disk_initialize (BYTE pdrv) __z88dk_fastcall;
;

; initialize the ide drive

defc _disk_initialise_fastcall = asm_disk_initialise
