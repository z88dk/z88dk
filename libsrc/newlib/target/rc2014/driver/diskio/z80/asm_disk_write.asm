SECTION code_driver

PUBLIC asm_disk_write

EXTERN ide_write_sector

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
;
; DRESULT disk_write (
;   BYTE pdrv,                      /* Physical drive number to identify the drive */
;   const BYTE *buff,               /* Data to be written */
;   LBA_t sector,                   /* Start sector in LBA */
;   UINT count ) __z88dk_callee;    /* Number of sectors to write (<256) */
;
; entry
; a = number of sectors (< 256)
; bcde = LBA specified by the 4 bytes in BCDE
; hl = the address pointer to the buffer read from (incremented by ide_write_sector)
;
; exit
; hl = DRESULT, set carry flag
;

.asm_disk_write
    or a                        ; check sectors != 0
    jr Z,dresult_error

    push af                     ; save number of sectors
.loop
    push bc                     ; save LBA
    push de
    call ide_write_sector       ; with the logical block address in bcde, write one sector

    pop de
    pop bc
    jr NC,dresult_error

    pop af
    dec a
    jr Z,dresult_ok

    push af                     ; save number of sectors, free a for LBA increment testing
    inc de                      ; increment the LBA lower word
    ld a,e
    or a,d                      ; lower de word non-zero, therefore no carry to bc
    jp NZ,loop

    inc bc                      ; otherwise increment LBA upper word
    jp loop

.dresult_ok
    ld hl,0                     ; set DRESULT RES_OK
    scf
    ret

.dresult_error
    ld hl,1                     ; set DRESULT RES_ERROR
    pop af
    ret
