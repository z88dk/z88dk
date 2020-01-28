SECTION code_driver

PUBLIC asm_disk_read

EXTERN ide_read_sector

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
; hl = the address pointer to the buffer to fill (incremented by ide_read_sector)
;
; exit
; hl = DRESULT, set carry flag
;

asm_disk_read:
    or a                    ; check sectors != 0
    jr z, _disk_read_dresult_error

_disk_read_loop:
    call ide_read_sector    ; with the logical block address in bcde, read one sector
    jr nc, _disk_read_dresult_error
    dec a
    jr z, _disk_read_dresult_ok
    push af                 ; free a for LBA increment testing
    inc de                  ; increment the LBA lower word
    ld a, e
    or a, d                 ; lower de word non-zero, therefore no carry to bc
    pop af                  ; recover a value
    jr nz, _disk_read_loop
    inc bc                  ; otherwise increment LBA upper word
    jr _disk_read_loop

_disk_read_dresult_ok:
    ld hl, 0                ; set DRESULT RES_OK
    scf
    ret

_disk_read_dresult_error:
    ld hl, 1                ; set DRESULT RES_ERROR
    or a
    ret

