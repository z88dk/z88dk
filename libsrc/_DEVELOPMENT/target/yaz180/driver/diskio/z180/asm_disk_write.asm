SECTION code_driver

PUBLIC asm_disk_write

EXTERN ide_write_sector

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
;
; DRESULT disk_write (
;   BYTE pdrv,          /* Physical drive nmuber to identify the drive */
;   const BYTE *buff,   /* Data to be written */
;   DWORD sector,       /* Start sector in LBA */
;   UINT count          /* Number of sectors to write */ ) __z88dk_callee;
;
; entry
; a = number of sectors (< 256)
; bcde = LBA specified by the 4 bytes in BCDE
; hl = the address pointer to the buffer to fill
;
; exit
; a = number of written sectors (< 256), set carry flag
; bcde = LBA following sectors written
; hl = the address pointer to the buffer filled


asm_disk_write:
    push af                 ; save total sector count
    push hl                 ; save origin pointer
    or a                    ; check sectors != 0
    jr z, error
loop:
    call ide_write_sector    ; with the logical block address in bcde, write one sector
    jr nc, error
    dec a
    jr z, success
    push bc
    ld bc, 512
    add hl, bc              ; increment the buffer pointer by 512 bytes
    inc de                  ; increment the LBA lower word    
    ld b, a                 ; free a for LBA increment testing
    ld a, e
    or d                    ; lower de word non-zero, therefore no carry to bc
    ld a, b                 ; recover a value
    pop bc                  ; recover the bc value
    jr nz, loop
    inc bc                  ; otherwise increment LBA upper word
    jr loop
    
success:
    pop hl
    pop af
    scf
    ret

error:
    pop hl
    pop af
    or a
    ret
