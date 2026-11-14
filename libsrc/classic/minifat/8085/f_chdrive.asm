;
; f_chdrive. Outline is ChaN ff.c f_chdrive. One volume: "0:" and a
; path with no drive prefix are FR_OK. Any other "digit:" is rejected.
; path at sp+2. The caller cleans.
;
; 8085 reads a stacked argument with ld de,sp+n and ld hl,(de).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_chdrive
PUBLIC  f_chdrive

EXTERN  mf_drive
EXTERN  mf_ok

; Call. The path is at sp+2. The caller removes it.
; Return. HL = FRESULT and H = 0. Carry is set only on the mf_ok path.
; Clobber. AF, C, DE, HL. B stays.
_f_chdrive:
f_chdrive:
    ld      de,sp+2
    ld      hl,(de)
    ld      a,h
    or      l
    jp      Z,mf_ok                         ; a path pointer of 0 is FR_OK
    call    mf_drive
    ret     NC                              ; the prefix is not drive 0. HL holds the FRESULT
    jp      mf_ok
