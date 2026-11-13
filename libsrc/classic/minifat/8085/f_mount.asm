;
; f_mount. Outline is ChaN ff.c f_mount (R0.16): drive, drop the old
; object, register the new one, mount when opt is not 0.
; 80cc stack-pointer order. The caller cleans. Last argument at sp+2.
; opt at sp+2, path at sp+4, fs at sp+6.
; A dirty file cache is discarded. Close a file before mounting again.
;
; 8085 reads a stacked argument with ld de,sp+n and ld hl,(de).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_mount
PUBLIC  f_mount

EXTERN  mf_drive
EXTERN  mf_bump_id
EXTERN  mf_publish
EXTERN  mf_cwd_reset
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_mount
EXTERN  fat_fs
EXTERN  fat_path
EXTERN  fat_kind
EXTERN  fat_dp
EXTERN  fat_file_valid
EXTERN  fat_file_dirty
EXTERN  _cpm_fat_vol

; Register fs, or clear the volume when fs is null.
; Call. The caller removes the arguments.
; opt is a byte at sp+2. path is at sp+4. fs is at sp+6.
; Return. HL is FR_OK and carry is set when the call succeeds.
; A bad drive prefix returns FR_INVALID_DRIVE. H is 0 and carry is clear.
; A mount failure returns L as 1, 3, 13, or 19. H is 0 and carry is clear.
; Clobber. AF, BC, DE, HL.
; Writes. The FATFS object and the file-cache flags. A null fs clears the volume.
_f_mount:
f_mount:
    ld      de,sp+2
    ld      a,(de)
    ld      (fat_kind),a
    ld      de,sp+4
    ld      hl,(de)
    ld      (fat_path),hl
    ld      de,sp+6
    ld      hl,(de)
    ld      (fat_dp),hl
    ld      hl,(fat_path)
    ld      a,h
    or      l
    jr      Z,fm_reg                        ; the path pointer is null
    call    mf_drive
    ret     NC                              ; HL is FR_INVALID_DRIVE and carry is clear
; Clear the file cache. Drop the type of an old object.
fm_reg:
    xor     a
    ld      (fat_file_valid),a
    ld      (fat_file_dirty),a
    call    mf_bump_id
    ld      hl,(fat_fs)
    ld      a,h
    or      l
    jr      Z,fm_new                        ; no old FATFS object is registered
    ld      (hl),0                          ; the old fs_type is 0
; Register fs, or unmount when fs is null.
fm_new:
    ld      hl,(fat_dp)
    ld      a,h
    or      l
    jr      Z,fm_off                        ; fs is null
    ld      (fat_fs),hl
    ld      (hl),0                          ; fs_type stays 0 until the publish
    inc     hl
    ld      (hl),0                          ; the drive byte is 0
    ld      a,(fat_kind)
    or      a
    jp      Z,mf_ok                         ; opt is 0. Do not mount.
    call    fat_mount
    jr      NC,fm_fail                      ; fat_mount failed
    call    mf_publish
    call    mf_cwd_reset
    jp      mf_ok
; Return the same L that fat_mount stored.
fm_fail:
    ld      a,l                             ; 1 sector error. 3 not ready. 13 no filesystem. 19 is a cluster size of 64 KiB or more.
    jp      mf_err
; fs is null. Clear the registered object and the volume type.
fm_off:
    ld      hl,0
    ld      (fat_fs),hl
    xor     a
    ld      (_cpm_fat_vol),a                ; fs_type 0 means no volume
    jp      mf_ok
