SECTION code_driver

PUBLIC _disk_read

EXTERN asm_disk_read

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
;
; DRESULT disk_read (
;   BYTE pdrv,              /* Physical drive number to identify the drive */
;   BYTE *buff,             /* Data buffer to store read data */
;   DWORD sector,           /* Start sector in LBA */
;   UINT count );           /* Number of sectors to read (<256) */
;
; entry
; a = number of sectors (< 256)
; bcde = LBA specified by the 4 bytes in BCDE
; hl = the address pointer to the buffer to fill
;

_disk_read:
    pop af      ; pop return address
    ex af,af
 
    inc sp      ; drop single byte pdrv (not evaluated)
    pop hl      ; buff to hl
    pop de      ; start sector to bcde
    pop bc
    dec sp      ; move sp to get a
    pop af      ; get sector count to a
    inc sp

    call asm_disk_read

    dec sp      ; make sure we don't overwrite stack with a from af
    push af     ; push sectors read
    inc sp
    push bc
    push de
    push hl
    dec sp      ; leave a byte for pdrv (not used)

    ex af,af
    push af     ; push return address

    ret
