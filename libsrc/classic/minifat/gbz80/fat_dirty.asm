;
; fat_dirty: mark the sector window dirty.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_dirty

EXTERN  fat_wflag

_fat_dirty:
    ld      a,1
    ld      (fat_wflag),a
    ret
