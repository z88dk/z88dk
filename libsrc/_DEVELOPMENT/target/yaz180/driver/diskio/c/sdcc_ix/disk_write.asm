SECTION code_driver

PUBLIC _disk_write

EXTERN asm_disk_write

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
;
; DRESULT disk_write (
;   BYTE pdrv,              /* Physical drive number to identify the drive */
;   const BYTE *buff,       /* Data to be written */
;   DWORD sector,           /* Start sector in LBA */
;   UINT count );           /* Number of sectors to write (<256) */
;
; entry
; a = number of sectors (< 256)
; bcde = LBA specified by the 4 bytes in BCDE
; hl = the address pointer to the buffer to fill
;

_disk_write:
    pop af      ; pop return address
    ex af,af

    inc sp      ; drop single byte pdrv (not evaluated)
    pop hl      ; buff to hl
    pop de      ; start sector to bcde
    pop bc
    dec sp      ; move sp to get a
    pop af      ; get sector count to a
    inc sp

    call asm_disk_write

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
