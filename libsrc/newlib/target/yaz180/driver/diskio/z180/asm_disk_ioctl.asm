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
; no guarentee that buff will be large enough to hold the whole ioctl 512 byte
; response. so use our own buffer, ideBuffer.
;
; exit
; hl = DRESULT, set carry flag
;
    
; control the ide drive

asm_disk_ioctl:
    push af
    push de

    xor a                   ; clear a
    or c                    ; check that that it is drive 0
    jr nz, dresult_error

    inc b                   ; use the command byte in b, to switch the action
    djnz get_sector_count

    call ide_cache_flush    ; cmd = 0
    jr nc, dresult_error
    jr dresult_ok

get_sector_count:
    djnz get_sector_size
    
    push hl                 ; save the calling buffer origin
    ld hl, ideBuffer        ; insert our own scratch buffer
    call ide_drive_id       ; cmd = 1 get the drive id info.

    pop de                  ; get calling buffer origin in de
    ld bc, 4                ; put the number of bytes in bc
    ld hl, ideBuffer+120    ; point to Word 60, 61
    
    jr nc, dresult_error

    ldir                    ; if all good then copy 4 bytes
    jr dresult_ok

get_sector_size:
    djnz get_block_size

    ld (hl), 0              ; cmd = 2
    inc hl
    ld (hl), 2              ; set value at pointer to 0x0200 (512)
    jr dresult_ok

get_block_size:
    djnz ata_get_rev

    ld (hl), 1              ; cmd = 3
    inc hl
    ld (hl), 0              ; set value at pointer to 0x0001 sectors
    jr dresult_ok

dresult_error:
    ld hl, 1                ; set DRESULT RES_ERROR
    pop de
    pop af
    or a
    ret

dresult_ok:
    ld hl, 0                ; set DRESULT RES_OK
    pop de
    pop af
    scf
    ret

ata_get_rev:
    ld a, b
    sub 17                  ; jump gap to next ATA commands
    ld b, a
    jr nz, ata_get_model

    push hl                 ; save the output buffer origin
    ld hl, ideBuffer        ; insert our own scratch buffer
    call ide_drive_id       ; cmd = 20 get the drive firmware revision.

    ld bc, 8                ; number of bytes (8) to move
    pop de                  ; get calling buffer origin in de
    ld hl, ideBuffer+46     ; prepare the firmware offset
    
    jr nc, dresult_error    

    call copy_word          ; 8 bytes
    jr dresult_ok

ata_get_model:
    djnz ata_get_sn

    push hl                 ; save the output buffer origin
    ld hl, ideBuffer        ; insert our own scratch buffer
    call ide_drive_id       ; cmd = 21 get the drive model number.

    ld bc, 40               ; number of bytes (40) to move
    pop de                  ; get calling buffer origin in de
    ld hl, ideBuffer+54     ; prepare the model number offset

    jr nc, dresult_error

    call copy_word          ; 40 bytes
    jr dresult_ok
     
ata_get_sn:
    djnz dresult_par_error

    push hl                 ; save the output buffer origin
    ld hl, ideBuffer        ; insert our own scratch buffer
    call ide_drive_id       ; cmd = 22 get the serial number.

    ld bc, 20               ; number of bytes (20) to move
    pop de                  ; get calling buffer origin in de
    ld hl, ideBuffer+20     ; prepare the serial number offset

    jr nc, dresult_error

    call copy_word          ; 20 bytes
    jr dresult_ok

dresult_par_error:
    ld hl, 4                ; set DRESULT RES_PARERR
    pop de
    pop af
    or a
    ret

    ; Copy a string pointed to by HL into DE, no more than BC bytes long.
    ; The IDE strings are stored as Words in LSB first (i.e. byte swapped).
    ; Fetch each word and swap so the IDE 16bit names print correctly.
copy_word:
    inc hl
    ldi                 ; Get MSB byte Copy it
    dec hl
    dec hl
    ldi                 ; Get LSB byte, Copy it
    inc hl
    jp pe, copy_word    ; Continue until BC = 00 (p/v reset)
    xor a
    ld (de), a          ; add a null on the end of the string
    ret
