;
; f_opendir. Outline is ChaN ff.c f_opendir (R0.16). A missing path
; is FR_NO_PATH. A file is FR_NO_PATH. "." and the root are the
; directory itself. path at sp+2, dp at sp+4. The caller cleans.
;
; ld hl,sp+n is native and forces Z = 0.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_opendir
PUBLIC  f_opendir

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  dir_sdi
EXTERN  fat_path
EXTERN  fat_dp
EXTERN  fat_noname
EXTERN  fat_attr
EXTERN  fat_here
EXTERN  fat_mount_id

; Open the directory named by path.
; Call. The caller removes the arguments. path is at sp+2. dp is at sp+4.
; Return. HL is FR_OK and carry is set.
; Failure is HL = FRESULT, H is 0, and carry is clear.
; A failed mount returns the same L that fat_mount stored, or FR_NOT_ENABLED.
; 1 is a sector error. 3 is not ready. 13 is no filesystem.
; 19 is a cluster size of 64 KiB or more.
; Clobber. AF, BC, DE, HL.
; Writes. The DIR object. A failed dir_sdi clears the object id.
_f_opendir:
f_opendir:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; path at sp+2
    ld      (fat_path),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)                          ; dp at sp+4
    ld      a,d
    or      e
    jp      Z,od_bad                        ; dp is null
    ld      (fat_dp),de
    ld      b,20                            ; the DIR object is 20 bytes
    xor     a
; Zero the next DIR byte.
od_z:
    ld      (de),a
    inc     de
    dec     b
    jr      nz,od_z
    call    mf_ensure
    ret     NC                              ; HL already holds the FRESULT
    call    fat_ldhl
    defw    fat_path
    call    mf_follow
    jp      NC,od_miss
    ld      a,(fat_noname)
    or      a
    jr      NZ,od_dir                       ; the path is this directory
    ld      a,(fat_attr)
    and     AM_DIR
    jp      Z,od_nopath
; Store the mount id and the start cluster, then rewind.
od_dir:
    call    fat_ldhl
    defw    fat_dp
    ld      de,(fat_mount_id)
    ld      (hl),e
    inc     hl
    ld      (hl),d                          ; the object id
    call    fat_ldhl
    defw    fat_dp
    ld      de,DIR_SCLUST
    add     hl,de
    ld      de,(fat_here)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      de,(fat_here+2)
    ld      (hl),e
    inc     hl
    ld      (hl),d                          ; the start cluster
    call    fat_ldhl
    defw    fat_dp
    ld      de,DIR_CLUST
    add     hl,de
    ld      de,(fat_here)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    ld      de,(fat_here+2)
    ld      (hl),e
    inc     hl
    ld      (hl),d                          ; the current cluster
    ld      de,(fat_here)
    ld      bc,(fat_here+2)
    ld      hl,0                            ; offset 0, the first entry
    call    dir_sdi
    jp      C,mf_ok                         ; the first sector is in the window
    call    fat_ldhl
    defw    fat_dp
    ld      (hl),0
    inc     hl
    ld      (hl),0                          ; clear the object id
    ld      a,FR_DISK_ERR
    jp      mf_err
; A file is not a directory.
od_nopath:
    ld      a,FR_NO_PATH
    jp      mf_err
; FR_NO_FILE from follow becomes FR_NO_PATH. Any other L stays.
od_miss:
    ld      a,l
    cp      FR_NO_FILE
    jr      NZ,od_err                       ; the miss is not FR_NO_FILE. Keep L.
    ld      a,FR_NO_PATH
od_err:
    jp      mf_err
; dp is null. There is no object to clear.
od_bad:
    ld      a,FR_INVALID_OBJECT
    jp      mf_err
