;
; f_chdrive. Outline is ChaN ff.c f_chdrive. One volume: "0:" and a
; path with no drive prefix are FR_OK. Any other "digit:" is rejected.
; path at sp+2. The caller cleans.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _f_chdrive
PUBLIC  f_chdrive

EXTERN  mf_drive
EXTERN  mf_ok

_f_chdrive:
f_chdrive:
    ld      hl,sp+2
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    push    de
    ld      de,hl
    pop     hl
    ld      a,h
    or      l
    jp      Z,mf_ok
    call    mf_drive
    ret     NC
    jp      mf_ok
