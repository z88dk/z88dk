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
; Entry:
;   a = number of sectors (< 256)
;   bcde = LBA specified by the 4 bytes in BCDE
;   hl = the address pointer to the buffer to fill

_disk_read:
    ld hl,9     ; get count into A
    add hl,sp
    ld a,(hl)

    dec hl      ; get LBA high into BC
    ld b,(hl)
    dec hl
    ld c,(hl)

    dec hl      ; get LBA low onto stack
    ld d,(hl)
    dec hl
    ld e,(hl)
    push de

    dec hl      ; get buffer * onto HL
    ld d,(hl)
    dec hl
    ld e,(hl)
    ex de,hl

    pop de      ; get LBA low from stack

    jp asm_disk_read
