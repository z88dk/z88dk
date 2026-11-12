;
; f_close. Outline is ChaN ff.c f_close: f_sync, then drop the object
; only when that sync returned FR_OK. fp at sp+2. The caller cleans.
;
; Copyright (c) October 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_close
PUBLIC  f_close

EXTERN  mf_fil_check
EXTERN  mf_sync_fil
EXTERN  mf_ok
EXTERN  fat_fp

_f_close:
f_close:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    ld      (fat_fp),de
    ex      de,hl
    call    mf_fil_check
    ret     NC
    call    mf_sync_fil
    ret     NC
    ld      hl,(fat_fp)
    ld      (hl),0
    inc     hl
    ld      (hl),0
    jp      mf_ok
