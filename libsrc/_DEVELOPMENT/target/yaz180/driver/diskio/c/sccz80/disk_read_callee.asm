SECTION code_driver

PUBLIC _disk_read_callee

EXTERN asm_disk_read

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
;
; DRESULT disk_read (
;   BYTE pdrv,                      /* Physical drive number to identify the drive */
;   BYTE *buff,                     /* Data buffer to store read data */
;   DWORD sector,                   /* Start sector in LBA */
;   UINT count ) __z88dk_callee;    /* Number of sectors to read (<256) */
;
; entry
; a = number of sectors (< 256)
; bcde = LBA specified by the 4 bytes in BCDE
; hl = the address pointer to the buffer to fill
;

_disk_read_callee:
    pop af      ; pop return address
    ex af,af

    dec sp      ; move sp to get a    
    pop af      ; get sector count to a  
    pop de      ; start sector to bcde
    pop bc
    pop hl      ; buff to hl    
    inc sp      ; drop pdrv (not evaluated)
    inc sp

    ex af,af
    push af     ; push return address

    jp asm_disk_read
