;
; f_open. Outline is ChaN ff.c f_open (R0.16): reject a null object,
; mount, follow the path, create or open, truncate on FA_CREATE_ALWAYS.
; FA_OPEN_APPEND seeks to the end and fills a partial sector.
; mode is at sp+2, path is at sp+4, fp is at sp+6.
; The caller removes the arguments.
; An error leaves the object id at 0.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_open
PUBLIC  f_open

EXTERN  mf_ensure
EXTERN  mf_follow
EXTERN  mf_bind
EXTERN  mf_trunc
EXTERN  mf_place
EXTERN  mf_sector_for_fptr
EXTERN  mf_cache_prepare
EXTERN  mf_save_dir
EXTERN  mf_mark_arc
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  dir_create
EXTERN  fat_fp
EXTERN  fat_path
EXTERN  fat_mode
EXTERN  fat_noname
EXTERN  fat_attr
EXTERN  fat_name11
EXTERN  fat_found_sclust
EXTERN  fat_found_size
EXTERN  fat_write

; Open or create the file named by path.
; Call. The caller removes the arguments.
; mode is a byte at sp+2. path is at sp+4. fp is at sp+6.
; Return. HL is FR_OK and carry is set.
; Failure is HL = FRESULT, H is 0, and carry is clear.
; A failed mount returns the same L that fat_mount stored, or FR_NOT_ENABLED.
; 1 is a sector error. 3 is not ready. 13 is no filesystem.
; 19 is a cluster size of 64 KiB or more.
; Clobber. AF, BC, DE, HL.
; Writes. The FIL object. An error stores 0 in the object id.
_f_open:
f_open:
    ld      hl,sp+2
    ld      a,(hl)                  ;mode, the last argument
    and     FA_MODE_MASK            ;$3F. Drop FA_MODIFIED and FA_DIRTY.
    ld      (fat_mode),a
    inc     hl
    inc     hl                      ;a byte argument occupies a word
    ld      e,(hl+)
    ld      d,(hl)                  ;path at sp+4
    ld      (fat_path),de
    inc     hl
    ld      e,(hl+)
    ld      d,(hl)                  ;fp at sp+6
    ld      a,d
    or      e
    jp      Z,fo_null               ;fp is null
    ld      (fat_fp),de
    ld      hl,(fat_fp)
    ld      b,FIL_BYTES             ;FIL_BYTES is 32
    xor     a
; Zero the next byte of the FIL object.
fo_z:
    ld      (hl+),a
    djnz    fo_z                    ;more FIL bytes remain
    call    mf_ensure
    jp      NC,fo_keep              ;mount failed. L is 1, 3, 13, or 19, or FR_NOT_ENABLED.
    ld      hl,(fat_path)
    call    mf_follow
    jr      NC,fo_absent            ;the path was not found
    ld      a,(fat_mode)
    and     FA_CREATE_MASK          ;create bits $1C
    jr      Z,fo_old                ;no create bit. Open the old object.
    ld      a,(fat_noname)
    or      a
    jp      NZ,fo_name              ;the path names a directory, not a file
    ld      a,(fat_mode)
    and     FA_CREATE_NEW
    jp      NZ,fo_exist             ;FA_CREATE_NEW refuses an existing name
    ld      a,(fat_attr)
    and     AM_RDO|AM_DIR
    jp      NZ,fo_deny              ;the entry is read-only or a directory
    ld      a,(fat_mode)
    and     FA_CREATE_ALWAYS
    jr      Z,fo_bound              ;keep the old size
    call    mf_bind
    call    mf_trunc                ;FA_CREATE_ALWAYS replaces the old chain
    jp      NC,fo_keep              ;truncate failed. L is FR_DISK_ERR.
    jr      fo_tail
; The name is missing. Create it when the mode asks for a create.
fo_new:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,fo_keep              ;the miss is not FR_NO_FILE. Keep L.
    ld      hl,fat_name11
    call    dir_create
    jp      NC,fo_deny              ;the directory has no free entry
    ld      hl,fat_found_sclust
    ld      b,8                     ;cluster and size, eight bytes
    xor     a
; Zero the next found-cluster or found-size byte.
fo_zf:
    ld      (hl+),a
    djnz    fo_zf
    call    mf_mark_arc
    call    mf_save_dir
    ld      a,(fat_mode)
    or      FA_MODIFIED             ;FA_MODIFIED means the directory entry needs an update
    ld      (fat_mode),a
    jr      fo_bound
; Follow failed. Create only when a create bit is set.
fo_absent:
    ld      a,(fat_mode)
    and     FA_CREATE_MASK
    jp      Z,fo_keep               ;the mode does not create. Keep L.
    jp      fo_new
; The object exists and the mode does not create.
fo_old:
    ld      a,(fat_noname)
    or      a
    jp      NZ,fo_name              ;the path names a directory, not a file
    ld      a,(fat_attr)
    and     AM_DIR
    jp      NZ,fo_nofile            ;a directory is not a file
    ld      a,(fat_mode)
    and     FA_WRITE                ;FA_WRITE is $02. The open asks to write.
    jr      Z,fo_bound              ;read only. A read-only attribute is allowed.
    ld      a,(fat_attr)
    and     AM_RDO
    jr      NZ,fo_deny              ;the entry is read-only
; Copy the found entry into the FIL object.
fo_bound:
    call    mf_bind
; Seek to the size when FA_SEEKEND is set. FA_OPEN_APPEND includes that bit.
fo_tail:
    ld      a,(fat_mode)
    and     FA_SEEKEND
    jp      Z,mf_ok                 ;FA_SEEKEND is clear
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      a,(hl+)
    or      (hl+)
    or      (hl+)
    or      (hl)
    jp      Z,mf_ok                 ;the size is 0. The pointer is already there.
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_found_size
    ld      bc,4
    ldir                            ;copy the size
    ld      hl,fat_found_size
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_FPTR
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    ldir                            ;the file pointer becomes the size
    call    mf_place
    jp      NC,fo_keep              ;the cluster for this offset was not found
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl+)
    jr      NZ,fo_fill              ;the low byte is not 0. The sector is partial.
    ld      a,(hl)
    and     1                       ;bit 8 of the file pointer
    jp      Z,mf_ok                 ;the pointer is on a 512-byte boundary
; Read the partial sector into the cache. fat_write stays 0.
fo_fill:
    xor     a
    ld      (fat_write),a
    call    mf_sector_for_fptr
    jr      NC,fo_sec               ;no sector for this file pointer
    call    mf_cache_prepare
    jp      C,mf_ok                 ;the cache holds the sector
    jp      fo_keep                 ;the cache was not filled. L is FR_DISK_ERR.
; HL is 0 when the helper found no sector. Any other HL is a FRESULT.
fo_sec:
    ld      a,h
    or      l
    jr      NZ,fo_keep              ;keep L from the sector helper
    ld      a,FR_INT_ERR
    jr      fo_bad
fo_name:
    ld      a,FR_INVALID_NAME
    jr      fo_bad
fo_exist:
    ld      a,FR_EXIST
    jr      fo_bad
fo_deny:
    ld      a,FR_DENIED
    jr      fo_bad
fo_nofile:
    ld      a,FR_NO_FILE
; Clear the object id and return the code in A.
fo_bad:
    call    fo_kill
    jp      mf_err
; L already holds the FRESULT. Clear the object id.
fo_keep:
    ld      a,l
    call    fo_kill
    jp      mf_err
; fp is null. There is no object id to clear.
fo_null:
    ld      a,FR_INVALID_OBJECT
    jp      mf_err
; Clear the FIL id. A null fp is left alone.
; Call. A holds the FRESULT code. fat_fp is the object or null.
; Return. AF is unchanged. The object id is 0 when fp is not null.
; Clobber. HL. AF, BC, and DE stay.
fo_kill:
    push    af
    ld      hl,(fat_fp)
    ld      a,h
    or      l
    jr      Z,fo_kill0              ;fp is null
    ld      (hl+),0
    ld      (hl),0                  ;the object id is 0
fo_kill0:
    pop     af
    ret
