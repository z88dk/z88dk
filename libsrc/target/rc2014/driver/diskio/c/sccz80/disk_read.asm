SECTION code_driver

PUBLIC disk_read

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
;
;   Stack: return address (2 bytes), count (1 byte, padded to 2), LBA byte 0 (LSB),
;           LBA byte 1, LBA byte 2, LBA byte 3 (MSB), buff (2 bytes), pdrv (1 byte, padded to 2)
; Exit:
;   A = count, BC = LBA high 16 bits (bytes 2-3), DE = LBA low 16 bits (bytes 0-1),
;           HL = buffer address
;   Stack: return address (2 bytes), count (1 byte, padded to 2), LBA byte 0 (LSB),
;           LBA byte 1, LBA byte 2, LBA byte 3 (MSB), buff (2 bytes), pdrv (1 byte, padded to 2)

IF __CPU_8085__

disk_read:
    ; Get count into A using LDSI and memory access
    ld de,sp+2      ; DE = SP + 2 = address of count
    ex de,hl        ; HL = SP + 2, DE = undefined
    ld a,(hl)       ; A = count from [HL]

    ; Get LBA low 16 bits (bytes 0-1) into DE using LDSI and memory access
    ld de,sp+4      ; DE = SP + 4 = address of LBA byte 0
    ld hl,(de)      ; L = [DE] (byte 0), H = [DE+1] (byte 1)
    push hl         ; Save LBA low on stack (H:L = byte 1:byte 0)

    ; Get LBA high 16 bits (bytes 2-3) into BC using LDSI and LHLX
    ld de,sp+8      ; DE = SP + 8 = address of LBA byte 2
    ld hl,(de)      ; L = [DE] (byte 2), H = [DE+1] (byte 3)
    ld bc,hl        ; Load LBA high (H:L = byte 3:byte 2) into BC

    ; Get buffer address into HL using LDSI and LHLX
    ld de,sp+10     ; DE = SP + 10 = address of buffer
    ld hl,(de)      ; L = [DE], H = [DE+1] = buffer address

    ; Restore LBA low into DE
    pop de          ; DE = LBA low (bytes 0-1)

    ; Stack has return address
    jp asm_disk_read

ELSE

disk_read:
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

    jp asm_disk_read

ENDIF
