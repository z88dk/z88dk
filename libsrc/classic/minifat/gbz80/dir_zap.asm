;
; dir_zap: mark the current directory entry deleted.
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  dir_zap
PUBLIC  _dir_zap

EXTERN  dir_ptr
EXTERN  fat_ldhl
EXTERN  fat_wflag

; ff.c dir_remove (no LFN): first byte := $E5. Does not free the chain.
_dir_zap:
dir_zap:
    call    fat_ldhl
    defw    dir_ptr
    ld      (hl),$E5                ;DDEM; chain free is the caller's job
    ld      a,1
    ld      (fat_wflag),a
    ld      hl,0
    scf                             ;C: dirent marked deleted
    ret
