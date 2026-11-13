;
; f_getfree. Outline is ChaN ff.c f_getfree. The count comes from the
; core walk. fatfs at sp+2, nclst at sp+4, path at sp+6.
;
; ld hl,sp+n is native and forces Z = 0.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_getfree
PUBLIC  f_getfree

EXTERN  mf_ensure
EXTERN  mf_drive
EXTERN  mf_ok
EXTERN  mf_err
EXTERN  _fat_getfree
EXTERN  fat_fs
EXTERN  fat_path
EXTERN  fat_user
EXTERN  fat_dp

; Call. The FATFS pointer is at sp+2. The nclst pointer is at sp+4.
; The path is at sp+6. The caller removes the arguments.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, BC, DE, HL.
; Writes. Success stores the free cluster count through nclst.
; Success stores the volume address through a non-null FATFS pointer.
_f_getfree:
f_getfree:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_dp),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_user),de
    inc     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_path),de
    call    mf_ensure
    ret     NC                              ; the volume is not mounted. HL holds the FRESULT
    call    fat_ldhl
    defw    fat_path
    ld      a,h
    or      l
    jr      Z,fg_cnt                        ; the path pointer is 0
    call    mf_drive
    ret     NC                              ; the prefix is not drive 0. HL holds the FRESULT
fg_cnt:
    call    fat_ldhl
    defw    fat_user
    ld      a,h
    or      l
    jr      NZ,fg_call                      ; the nclst pointer is present
    ld      a,FR_INVALID_PARAMETER          ; the nclst pointer is 0
    jp      mf_err
fg_call:
    call    _fat_getfree                    ; HL is the nclst pointer
    jr      C,fg_ptr                        ; the free count was stored
    ld      a,FR_DISK_ERR                   ; the count walk failed
    jp      mf_err
fg_ptr:
    call    fat_ldhl
    defw    fat_dp
    ld      a,h
    or      l
    jp      Z,mf_ok                         ; the FATFS pointer is 0
    ld      de,(fat_fs)
    ld      (hl),e                          ; store the volume address
    inc     hl
    ld      (hl),d
    jp      mf_ok
