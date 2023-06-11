SECTION code_driver

PUBLIC disk_write

EXTERN asm_disk_write

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
;
; DRESULT disk_write (
;   BYTE pdrv,              /* Physical drive number to identify the drive */
;   const BYTE *buff,       /* Data to be written */
;   LBA_t sector,           /* Start sector in LBA */
;   UINT count );           /* Number of sectors to write (<256) */
;
; entry
; a = number of sectors (< 256)
; bcde = LBA specified by the 4 bytes in BCDE
; hl = the address pointer to the buffer to read from
;

disk_write:
    inc sp      ; pop return address
;   inc sp

;   dec sp
    pop af      ; get BYTE sector count to a
    inc sp

    pop de      ; lba to bcde
    pop bc

    pop hl      ; *buff to hl

    dec sp      ; balance pop *buff
    dec sp

    dec sp      ; balance pop lba
    dec sp
    dec sp
    dec sp

    dec sp      ; balance ns
    dec sp

    dec sp      ; balance return address
    dec sp

    jp asm_disk_write
