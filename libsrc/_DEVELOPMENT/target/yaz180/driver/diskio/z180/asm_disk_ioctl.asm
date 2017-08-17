SECTION code_driver

PUBLIC asm_disk_ioctl

EXTERN ide_drive_id
EXTERN ide_cache_flush

EXTERN ideStatus, ideBuffer

EXTERN l_fast_mulu_32_16x16, l_fast_mulu_32_32x32

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

; entry
; c = BYTE pdrv
; b = BYTE cmd
; hl = void* buff (for the result)
;
; no guarentee that buff will be large enough to hold the whole ioctl response
; so use our own buffer, ideBuffer.
;
; exit
; l = DRESULT, set carry flag
;
    
; control the ide drive

asm_disk_ioctl:
    push af
    push de

    xor a                   ; clear a
    or c                    ; check that that it is drive 0
    jr nz, dresult_error
    
    inc b                   ; start checking the cmd byte in b
    djnz get_sector_count

    call ide_cache_flush    ; cmd = 0
    jr nc, dresult_error
    jr dresult_ok

get_sector_count:
    djnz get_sector_size
    
    push hl                 ; save the output buffer origin
    ld hl, ideBuffer        ; insert our own scratch buffer
    call ide_drive_id       ; cmd = 1 get the drive id info.
    jr nc, dresult_error

    ld bc, 4                ; number of bytes to move
    pop de                  ; get calling buffer origin in de
    ld hl, ideBuffer+120    ; prepare the logical sectors offset
    ldir                    ; 4 bytes
    
    ld a, (hl)

    jr dresult_ok

get_sector_size:
    djnz get_block_size

    ld (hl), 0              ; cmd = 2
    inc hl
    ld (hl), 2              ; set value at pointer to 0x200 (512)
    jr dresult_ok

get_block_size:
    djnz ata_get_rev

    ld (hl), 0              ; cmd = 3
    inc hl
    ld (hl), 2              ; set value at pointer to 0x200 (512)
    jr dresult_ok

dresult_ok:
    ld hl, 0                ; set DRESULT RES_OK
    pop de
    pop af
    scf
    ret

dresult_error:
    ld hl, 1                ; set DRESULT RES_ERROR
    pop de
    pop af
    or a
    ret

ata_get_rev:
    ld a, b
    sub 17                  ; gap to next ATA commands
    ld b, a
    jr nz, ata_get_model

    push hl                 ; save the output buffer origin
    ld hl, ideBuffer        ; insert our own scratch buffer
    call ide_drive_id       ; cmd = 20 get the drive firmware revision.
    jr nc, dresult_error

    ld bc, 8                ; number of bytes to move
    pop de                  ; get calling buffer origin in de
    ld hl, ideBuffer+46     ; prepare the firmware offset
    ldir                    ; 8 bytes
    jr dresult_ok

ata_get_model:
    djnz ata_get_sn

    push hl                 ; save the output buffer origin
    ld hl, ideBuffer        ; insert our own scratch buffer
    call ide_drive_id       ; cmd = 21 get the drive model number.
    jr nc, dresult_error

    ld bc, 40               ; number of bytes to move
    pop de                  ; get calling buffer origin in de
    ld hl, ideBuffer+54     ; prepare the model number offset
    ldir                    ; 40 bytes
    jr dresult_ok
     
ata_get_sn:
    djnz dresult_error

    push hl                 ; save the output buffer origin
    ld hl, ideBuffer        ; insert our own scratch buffer
    call ide_drive_id       ; cmd = 22 get the serial number.
    jr nc, dresult_error

    ld bc, 20               ; number of bytes to move
    pop de                  ; get calling buffer origin in de
    ld hl, ideBuffer+20     ; prepare the serial number offset
    ldir                    ; 20 bytes
    jr dresult_ok

