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
; Entry:
;   a = number of sectors (< 256)
;   bcde = LBA specified by the 4 bytes in BCDE
;   hl = the address pointer to the buffer to fill
;
;   Stack: return address (2 bytes), count (1 byte, padded to 2), LBA byte 0 (LSB),
;           LBA byte 1, LBA byte 2, LBA byte 3 (MSB), buff (2 bytes), pdrv (1 byte, padded to 2)
; Exit:
;   A = count, BC = LBA high 16 bits (bytes 2-3), DE = LBA low 16 bits (bytes 0-1),
;           HL = buffer address
;   Stack: return address (2 bytes)

disk_read_callee:
    ; Store return address in unused pdrv location
    pop de      ; Return address in DE
    ld hl,8     ; DE = SP + 8 = address of pdrv
    add hl,sp
    ld (hl),e   ; Store return address
    inc hl
    ld (hl),d

    pop bc      ; get UINT sector count to a
    ld a,c

    pop de      ; start sector to bcde
    pop bc

    pop hl      ; get *buff

    ; Stack has return address
    jp asm_disk_read
