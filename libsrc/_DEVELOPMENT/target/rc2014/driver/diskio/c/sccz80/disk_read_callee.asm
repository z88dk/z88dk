SECTION code_driver

PUBLIC disk_read_callee

EXTERN asm_disk_read

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
;
; DRESULT disk_read (
;   BYTE pdrv,                      /* Physical drive number to identify the drive */
;   BYTE *buff,                     /* Data buffer to store read data */
;   LBA_t sector,                   /* Start sector in LBA */
;   UINT count ) __z88dk_callee;    /* Number of sectors to read (<256) */
;
; entry
; a = number of sectors (< 256)
; bcde = LBA specified by the 4 bytes in BCDE
; hl = the address pointer to the buffer to fill
;

disk_read_callee:
    pop hl      ; pop return address

    dec sp
    pop af      ; get BYTE sector count to a
    inc sp

    pop de      ; start sector to bcde
    pop bc

    inc sp      ; bypass *buff
    inc sp

    ex (sp),hl  ; return address on stack, over pdrv

    dec sp      ; go back for *buff
    dec sp

    pop hl      ; get *buff

    jp asm_disk_read
