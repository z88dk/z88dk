;
; fat_dirty: mark the sector window dirty.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_dirty

EXTERN  fat_wflag

; Mark the sector window dirty.
; Call. The caller passes no arguments.
; Return. No status. A is 1.
; Writes. fat_wflag is 1.
; Clobber. A. F, BC, DE, and HL stay.
_fat_dirty:
    ld      a,1
    ld      (fat_wflag),a           ;window needs a write
    ret
