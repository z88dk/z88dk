;
; f_close. Outline is ChaN ff.c f_close: f_sync, then drop the object
; only when that sync returned FR_OK. fp at sp+2. The caller cleans.
;
; ld hl,sp+n is native and forces Z = 0.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib
EXTERN  fat_ldhl

PUBLIC  _f_close
PUBLIC  f_close

EXTERN  mf_fil_check
EXTERN  mf_sync_fil
EXTERN  mf_ok
EXTERN  fat_fp

; Call. The FIL pointer is at sp+2. The caller removes it.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, BC, DE, HL.
; Writes. Success stores the directory entry when the file is modified.
; Success then clears the file id.
_f_close:
f_close:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_fp),de
    ld      hl,de
    call    mf_fil_check
    ret     NC                              ; mf_fil_check failed. HL holds the FRESULT
    call    mf_sync_fil
    ret     NC                              ; mf_sync_fil failed. HL holds the FRESULT
    call    fat_ldhl
    defw    fat_fp
    ld      (hl),0                          ; clear the file id
    inc     hl
    ld      (hl),0
    jp      mf_ok
