;
; f_readdir. Outline is ChaN ff.c f_readdir (R0.16) with FF_USE_LFN 0.
; dir_read skips a deleted entry, a dot name, AM_LFN, and a volume
; label. End of directory is FR_OK and an empty name. fno == NULL
; rewinds. fno at sp+2, dp at sp+4. The caller cleans.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_readdir
PUBLIC  f_readdir

EXTERN  mf_ok
EXTERN  mf_err
EXTERN  mf_fill_info
EXTERN  dir_sdi
EXTERN  dir_next
EXTERN  fat_dp
EXTERN  fat_user
EXTERN  fat_mount_id
EXTERN  _cpm_fat_vol
EXTERN  dir_ptr
EXTERN  dir_ofs

_f_readdir:
f_readdir:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_user),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      a,d
    or      e
    jp      Z,fr_bad
    ld      (fat_dp),de
    ld      a,(de)
    ld      l,a
    inc     de
    ld      a,(de)
    ld      h,a
    or      l
    jp      Z,fr_bad
    ld      de,(fat_mount_id)
    or      a
    sbc     hl,de
    jp      NZ,fr_bad
    ld      a,(_cpm_fat_vol)
    or      a
    jp      Z,fr_bad
    ld      hl,(fat_user)
    ld      a,h
    or      l
    jr      Z,fr_rewind
    ld      de,FI_NAME
    add     hl,de
    ld      (hl),0
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR+2
    add     hl,de
    ld      a,(hl)
    inc     hl
    or      (hl)
    jp      NZ,mf_ok
    call    fr_sdi_dptr
    jr      NC,fr_sdi_nc
fr_loop:
    ld      hl,(dir_ptr)
    ld      a,(hl)
    or      a
    jp      Z,mf_ok
    cp      $E5
    jr      Z,fr_skip
    cp      '.'
    jr      Z,fr_skip
    ld      de,DIR_Attr
    add     hl,de
    ld      a,(hl)
    cp      $0F
    jr      Z,fr_skip
    and     $DF
    cp      AM_VOL
    jr      Z,fr_skip
    ld      hl,(fat_user)
    call    mf_fill_info
    call    dir_next
    jr      NC,fr_mark
    call    fr_store
    jp      mf_ok
fr_skip:
    call    dir_next
    jp      NC,mf_ok
    call    fr_store
    jr      fr_loop
fr_sdi_nc:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR
    add     hl,de
    ld      a,(hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    inc     hl
    or      (hl)
    jp      NZ,mf_ok
    ld      a,FR_DISK_ERR
    jp      mf_err
fr_mark:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR+2
    add     hl,de
    ld      (hl),1
    inc     hl
    ld      (hl),0
    jp      mf_ok
fr_rewind:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR
    add     hl,de
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
    inc     hl
    ld      (hl),a
    inc     hl
    ld      (hl),a
    ld      hl,(fat_dp)
    ld      de,DIR_SCLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    ld      hl,0
    call    dir_sdi
    jp      C,mf_ok
    ld      a,FR_DISK_ERR
    jp      mf_err
fr_bad:
    ld      a,FR_INVALID_OBJECT
    jp      mf_err

; Open the directory at the low 16 bits of dptr.
fr_sdi_dptr:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    push    de
    ld      hl,(fat_dp)
    ld      de,DIR_SCLUST
    add     hl,de
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    inc     hl
    ld      c,(hl)
    inc     hl
    ld      b,(hl)
    pop     hl
    jp      dir_sdi

; Copy dir_ofs into the low half of dptr. The high half stays 0.
fr_store:
    ld      hl,(fat_dp)
    ld      de,DIR_DPTR
    add     hl,de
    ld      de,(dir_ofs)
    ld      (hl),e
    inc     hl
    ld      (hl),d
    inc     hl
    xor     a
    ld      (hl),a
    inc     hl
    ld      (hl),a
    ret
