;
; f_open. Outline is ChaN ff.c f_open (R0.16): reject a null object,
; mount, follow_path, create or open, truncate on FA_CREATE_ALWAYS,
; FA_OPEN_APPEND seeks to the end and fills a partial sector.
; mode at sp+2, path at sp+4, fp at sp+6. The caller cleans.
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
EXTERN  mf_copy
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

_f_open:
f_open:
    ld      hl,sp+2
    ld      a,(hl)
    and     FA_MODE_MASK
    ld      (fat_mode),a
    inc     hl
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_path),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jp      Z,fo_null
    ld      (fat_fp),de
    ld      hl,(fat_fp)
    ld      b,FIL_BYTES
    xor     a
fo_z:
    ld      (hl),a
    inc     hl
    dec     b
    jr      nz,fo_z
    call    mf_ensure
    jp      NC,fo_keep
    ld      hl,(fat_path)
    call    mf_follow
    jr      NC,fo_absent
    ld      a,(fat_mode)
    and     FA_CREATE_MASK
    jr      Z,fo_old
    ld      a,(fat_noname)
    or      a
    jp      NZ,fo_name
    ld      a,(fat_mode)
    and     FA_CREATE_NEW
    jp      NZ,fo_exist
    ld      a,(fat_attr)
    and     AM_RDO|AM_DIR
    jp      NZ,fo_deny
    ld      a,(fat_mode)
    and     FA_CREATE_ALWAYS
    jr      Z,fo_bound
    call    mf_bind
    call    mf_trunc
    jp      NC,fo_keep
    jr      fo_tail
fo_new:
    ld      a,l
    cp      FR_NO_FILE
    jp      NZ,fo_keep
    ld      hl,fat_name11
    call    dir_create
    jp      NC,fo_deny
    ld      hl,fat_found_sclust
    ld      b,8
    xor     a
fo_zf:
    ld      (hl),a
    inc     hl
    dec     b
    jr      nz,fo_zf
    call    mf_mark_arc
    call    mf_save_dir
    ld      a,(fat_mode)
    or      FA_MODIFIED
    ld      (fat_mode),a
    jr      fo_bound
fo_absent:
    ld      a,(fat_mode)
    and     FA_CREATE_MASK
    jp      Z,fo_keep
    jp      fo_new
fo_old:
    ld      a,(fat_noname)
    or      a
    jp      NZ,fo_name
    ld      a,(fat_attr)
    and     AM_DIR
    jp      NZ,fo_nofile
    ld      a,(fat_mode)
    and     FA_WRITE
    jr      Z,fo_bound
    ld      a,(fat_attr)
    and     AM_RDO
    jr      NZ,fo_deny
fo_bound:
    call    mf_bind
fo_tail:
    ld      a,(fat_mode)
    and     FA_SEEKEND
    jp      Z,mf_ok
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      a,(hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      Z,mf_ok
    ld      hl,(fat_fp)
    ld      de,FIL_SIZE
    add     hl,de
    ld      de,fat_found_size
    ld      bc,4
    call    mf_copy
    ld      hl,fat_found_size
    ld      de,(fat_fp)
    ld      a,e
    add     a,FIL_FPTR
    ld      e,a
    ld      a,d
    adc     a,0
    ld      d,a
    ld      bc,4
    call    mf_copy
    call    mf_place
    jp      NC,fo_keep
    ld      hl,(fat_fp)
    ld      de,FIL_FPTR
    add     hl,de
    ld      a,(hl)
    inc     hl
    jr      NZ,fo_fill
    ld      a,(hl)
    and     1
    jp      Z,mf_ok
fo_fill:
    xor     a
    ld      (fat_write),a
    call    mf_sector_for_fptr
    jr      NC,fo_sec
    call    mf_cache_prepare
    jp      C,mf_ok
    jp      fo_keep
fo_sec:
    ld      a,h
    or      l
    jr      NZ,fo_keep
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
fo_bad:
    call    fo_kill
    jp      mf_err
fo_keep:
    ld      a,l
    call    fo_kill
    jp      mf_err
fo_null:
    ld      a,FR_INVALID_OBJECT
    jp      mf_err
fo_kill:
    push    af
    ld      hl,(fat_fp)
    ld      a,h
    or      l
    jr      Z,fo_kill0
    ld      (hl),0
    inc     hl
    ld      (hl),0
fo_kill0:
    pop     af
    ret
