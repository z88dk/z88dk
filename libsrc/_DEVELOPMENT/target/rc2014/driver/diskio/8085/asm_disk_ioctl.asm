SECTION code_driver

PUBLIC asm_disk_ioctl

EXTERN ide_drive_id
EXTERN ide_cache_flush

EXTERN ideBuffer

;------------------------------------------------------------------------------
; Routines that talk with the IDE drive, these should be called from diskio.h
; extern DRESULT disk_ioctl (BYTE pdrv, BYTE cmd, void* buff) __z88dk_callee;
;

;
; Command codes for disk_ioctrl function
;

; /* Generic command (Used by FatFs) */
; #define CTRL_SYNC         0	/* Complete pending write process (_FS_READONLY == 0) */
; #define GET_SECTOR_COUNT  1	/* Get media size (_USE_MKFS == 1) */
; #define GET_SECTOR_SIZE   2	/* Get sector size (_MAX_SS != _MIN_SS) */
; #define GET_BLOCK_SIZE    3	/* Get erase block size (_USE_MKFS == 1) */
;
; /* ATA/CF specific ioctl command */
; #define ATA_GET_REV       20	/* Get F/W revision */
; #define ATA_GET_MODEL     21	/* Get model name */
; #define ATA_GET_SN        22	/* Get serial number */

; Some parameters are defined as a 16-bit value.
; A word that is defined as a 16-bit value places the most
; significant bit of the value on bit DD15
; and the least significant bit on bit DD0.

; Some parameters are defined as 32-bit values (e.g., words 60 and 61).
; Such fields are transferred using two successive word transfers.
; The device shall first transfer the least significant bits,
; bits 15 through 0 of the value, on bits DD (15:0) respectively.
; After the least significant bits have been transferred, the most
; significant bits, bits 31 through 16 of the value,
; shall be transferred on DD (15:0) respectively.

; entry
; c = BYTE pdrv
; b = BYTE cmd
; hl = void* buff (for the result)
;
; no guarantee that buff will be large enough to hold the whole ioctl 512 byte
; response. so use our own buffer, ideBuffer.
;
; exit
; hl = DRESULT, set carry flag
;
    
; control the ide drive

.asm_disk_ioctl
    push de

    xor a                       ; clear a
    or c                        ; check that that it is drive 0
    jr NZ,dresult_error

    inc b                       ; use the command byte in b, to switch the action
    dec b
    jr NZ,get_sector_count

    call ide_cache_flush        ; cmd = 0

    jr NC,dresult_error
    jr dresult_ok

.get_sector_count
    dec b
    jr NZ,get_sector_size

    push hl                     ; save the calling buffer origin
    ld hl, ideBuffer            ; insert our own scratch buffer
    call ide_drive_id           ; cmd = 1 get the drive id info.

    pop de                      ; get calling buffer origin in de
    ld hl, ideBuffer+120        ; point to Word 60, 61
    ld c,4                      ; copy 4 bytes

    jr NC,dresult_error

.copy_loop                      ; if all good then copy bytes
    ld a,(hl)
    inc hl
    ld (de),a
    inc de
    dec c
    jr NZ,copy_loop

    jr dresult_ok

.get_sector_size
    dec b
    jr NZ,get_block_size

    ld (hl),0                   ; cmd = 2
    inc hl
    ld (hl),2                   ; set value at pointer to 0x0200 (512)
    jr dresult_ok

.get_block_size
    dec b
    jr NZ,ata_get_rev

    ld (hl),1                   ; cmd = 3
    inc hl
    ld (hl),0                   ; set value at pointer to 0x0001 sectors
    jr dresult_ok

.dresult_error
    ld hl,1                     ; set DRESULT RES_ERROR
    pop de
    ret

.dresult_ok
    ld hl,0                     ; set DRESULT RES_OK
    pop de
    scf
    ret

.ata_get_rev
    ld a,b
    sub 17                      ; jump gap to next ATA commands
    jr C,dresult_par_error

    ld b,a
    jr NZ,ata_get_model

    push hl                     ; save the output buffer origin
    ld hl,ideBuffer             ; insert our own scratch buffer
    call ide_drive_id           ; cmd = 20 get the drive firmware revision.

    pop de                      ; get calling buffer origin in de
    ld hl,ideBuffer+46          ; prepare the firmware offset
    ld a,4                      ; number of words (4) to copy

    jr NC,dresult_error

    call copy_word              ; 8 bytes
    jr dresult_ok

.ata_get_model
    dec b
    jr NZ,ata_get_sn

    push hl                     ; save the output buffer origin
    ld hl,ideBuffer             ; insert our own scratch buffer
    call ide_drive_id           ; cmd = 21 get the drive model number.

    pop de                      ; get calling buffer origin in de
    ld hl,ideBuffer+54          ; prepare the model number offset
    ld a,20                     ; number of words (20) to copy

    jr NC,dresult_error

    call copy_word              ; 40 bytes
    jr dresult_ok
     
.ata_get_sn
    dec b
    jr NZ,dresult_par_error

    push hl                     ; save the output buffer origin
    ld hl,ideBuffer             ; insert our own scratch buffer
    call ide_drive_id           ; cmd = 22 get the serial number.

    pop de                      ; get calling buffer origin in de
    ld hl,ideBuffer+20          ; prepare the serial number offset
    ld a,10                     ; number of words (10) to copy

    jr NC,dresult_error

    call copy_word              ; 20 bytes
    jr dresult_ok

.dresult_par_error
    ld hl,4                     ; set DRESULT RES_PARERR
    pop de
    or a
    ret

    ; Copy a string pointed to by HL into DE, no more than A*2 bytes long.
    ; The IDE strings are stored as Words in LSB first (i.e. byte swapped).
    ; Fetch each word and swap so the IDE 16 bit names print correctly.
copy_word:
    ld c,(hl)                   ; Get LSB byte Copy it
    inc hl
    ld b,(hl)                   ; Get MSB byte Copy it
    inc hl

    ex de,hl
    ld (hl),b
    inc hl
    ld (hl),c
    inc hl

    ex de,hl
    dec a
    jp NZ,copy_word             ; Continue until A = 00
    ld (de),a                   ; add a null on the end of the string
    ret

