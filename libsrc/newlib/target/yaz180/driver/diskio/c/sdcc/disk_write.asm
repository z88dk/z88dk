SECTION code_driver

PUBLIC _disk_write

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
; Entry
;   a = number of sectors (< 256)
;   bcde = LBA specified by the 4 bytes in BCDE
;   hl = the address pointer to the buffer to read from

_disk_write:
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

    jp asm_disk_write
