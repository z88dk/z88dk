;
; f_closedir. Outline is ChaN ff.c f_closedir: a live object is dropped.
; dp at sp+2. The caller cleans.
;
; ld hl,sp+n is native and forces Z = 0.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

EXTERN  mf_subhlbc

PUBLIC  _f_closedir
PUBLIC  f_closedir

EXTERN  mf_ok
EXTERN  mf_err
EXTERN  fat_dp
EXTERN  fat_mount_id
EXTERN  _cpm_fat_vol

; Call. The DIR pointer is at sp+2. The caller removes it.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, DE, HL. BC stays.
; Writes. Success stores 0 in the directory id.
_f_closedir:
f_closedir:
    ld      hl,sp+2
    ld      e,(hl+)
    ld      d,(hl)
    ld      a,d
    or      e
    jr      Z,fd_bad                        ; the DIR pointer is 0
    ld      (fat_dp),de
    ld      a,(de)
    ld      l,a
    inc     de
    ld      a,(de)
    ld      h,a
    or      l
    jr      Z,fd_bad                        ; the directory id is 0
    ld      de,(fat_mount_id)
    or      a                               ; clear carry before the subtract
    push    bc
    ld      bc,de
    call    mf_subhlbc
    pop     bc
    jr      NZ,fd_bad                       ; the id is not this mount
    ld      a,(_cpm_fat_vol)
    or      a
    jr      Z,fd_bad                        ; fs_type is 0. No volume is mounted
    call    fat_ldhl
    defw    fat_dp
    ld      (hl+),0                         ; clear the directory id
    ld      (hl),0
    jp      mf_ok
; the directory object is not live
fd_bad:
    ld      a,FR_INVALID_OBJECT
    jp      mf_err
