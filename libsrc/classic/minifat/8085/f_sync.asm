;
; f_sync. Outline is ChaN ff.c f_sync: validate, flush, write the
; directory entry when FA_MODIFIED is set, then sync the FAT window.
; fp at sp+2. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_sync
PUBLIC  f_sync

EXTERN  mf_fil_check
EXTERN  mf_sync_fil
EXTERN  fat_fp

_f_sync:
f_sync:
    ld      de,sp+2
    ld      hl,(de)
    ld      (fat_fp),hl
    call    mf_fil_check
    ret     NC
    jp      mf_sync_fil
