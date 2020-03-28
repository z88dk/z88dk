SECTION code_driver

PUBLIC _disk_read

EXTERN asm_disk_read

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
;
; DRESULT disk_read (
;   BYTE pdrv,              /* Physical drive number to identify the drive */
;   BYTE *buff,             /* Data buffer to store read data */
;   LBA_t sector,           /* Start sector in LBA */
;   UINT count );           /* Number of sectors to read (<256) */
;
; entry
; a = number of sectors (< 256)
; bcde = LBA specified by the 4 bytes in BCDE
; hl = the address pointer to the buffer to fill
;

_disk_read:
    inc sp      ; pop return address
    inc sp

    inc sp      ; drop single byte pdrv (not evaluated)

    pop hl      ; *buff to hl
    pop de      ; start sector to bcde
    pop bc
    dec sp      ; get BYTE sector count
    pop af      ; pop sector count into a

    dec sp      ; balance pop af

    dec sp      ; balance pop bc
    dec sp

    dec sp      ; balance pop de
    dec sp

    dec sp      ; balance pop hl
    dec sp

    dec sp      ; balance pdrv

    dec sp      ; balance return address
    dec sp

    jp asm_disk_read

