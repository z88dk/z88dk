SECTION code_driver

PUBLIC _disk_read_callee

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
; entry
; a = number of sectors (< 256)
; bcde = LBA specified by the 4 bytes in BCDE
; hl = the address pointer to the buffer to fill
;

_disk_read_callee:
    pop hl      ; pop return address

    inc sp      ; drop single byte pdrv (not evaluated)
    pop af      ; *buff to af
    pop de      ; start sector to bcde
    pop bc
    ex (sp),hl  ; get sector count to hl (return address on stack)

    push af     ; push *buff   
    push hl     ; push sector count
    dec sp      ; get BYTE sector count
    pop af      ; pop sector count into a
    inc sp      ; balance for sector pop
    pop hl      ; pop *buff

    jp asm_disk_read
