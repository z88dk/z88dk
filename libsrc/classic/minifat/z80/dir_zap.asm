;
; dir_zap: mark the current directory entry deleted.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  dir_zap
PUBLIC  _dir_zap

EXTERN  dir_ptr
EXTERN  fat_wflag

; Mark the current directory entry deleted.
; The caller frees the chain.
; Call. The caller passes no arguments.
; Return. L = 0 and H = 0. Carry is set.
; Writes. The first byte of the entry becomes $E5. fat_wflag is 1.
; Clobber. AF, HL. BC and DE stay.
_dir_zap:
dir_zap:
    ld      hl,(dir_ptr)
    ld      (hl),$E5                ;$E5 is a deleted entry
    ld      a,1
    ld      (fat_wflag),a           ;window needs a write
    ld      hl,0
    scf                             ;carry set
    ret
