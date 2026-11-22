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
; Entry:
;   a = number of sectors (< 256)
;   bcde = LBA specified by the 4 bytes in BCDE
;   hl = the address pointer to the buffer to read from
;
;   Stack: return address (2 bytes), count (1 byte, padded to 2), LBA byte 0 (LSB),
;           LBA byte 1, LBA byte 2, LBA byte 3 (MSB), buff (2 bytes), pdrv (1 byte, padded to 2)
; Exit:
;   A = count, BC = LBA high 16 bits (bytes 2-3), DE = LBA low 16 bits (bytes 0-1),
;           HL = buffer address
;   Stack: return address (2 bytes), count (1 byte, padded to 2), LBA byte 0 (LSB),
;           LBA byte 1, LBA byte 2, LBA byte 3 (MSB), buff (2 bytes), pdrv (1 byte, padded to 2)

disk_write:
    ld hl,2     ; get count into A
    add hl,sp
    ld a,(hl)

    inc hl      ; get LBA low onto stack
    inc hl
    ld e,(hl)
    inc hl
    ld d,(hl)
    push de

    inc hl      ; get LBA high into BC
    ld c,(hl)
    inc hl
    ld b,(hl)

    inc hl      ; get buffer * onto HL
    ld e,(hl)
    inc hl
    ld d,(hl)
    ex de,hl

    pop de      ; get LBA low from stack

    jp asm_disk_write
