;
; f_sync. Outline is ChaN ff.c f_sync: validate, flush, write the
; directory entry when FA_MODIFIED is set, then sync the FAT window.
; fp at sp+2. The caller cleans.
;
; 8085 reads a stacked argument with ld de,sp+n and ld hl,(de).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_sync
PUBLIC  f_sync

EXTERN  mf_fil_check
EXTERN  mf_sync_fil
EXTERN  fat_fp

; Call. The FIL pointer is at sp+2. The caller removes it.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, BC, DE, HL.
; Writes. The call writes the file sector when that sector is dirty.
; Success stores the directory entry of a modified file and clears FA_MODIFIED.
_f_sync:
f_sync:
    ld      de,sp+2
    ld      hl,(de)
    ld      (fat_fp),hl
    call    mf_fil_check
    ret     NC                              ; mf_fil_check failed. HL holds the FRESULT
    jp      mf_sync_fil                     ; mf_sync_fil returns the FRESULT
