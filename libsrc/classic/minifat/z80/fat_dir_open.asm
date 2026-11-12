;
; fat_dir_open: open a directory at its first entry.
; A pointer argument is __z88dk_fastcall (HL).
;
; Copyright (c) November 2026 Phillip Stevens (feilipu), MIT.

INCLUDE "minifat.inc"

SECTION code_lib

PUBLIC  _fat_dir_open

EXTERN  dir_sdi
EXTERN  fat_ld32

; Open a directory at its first entry.
; HL points at the little-endian start cluster. 0 is the root
; (the FAT16 root area, or the FAT32 root cluster).
; L=0 and carry set when the first sector is in the window.
; L=1 and carry clear when that cluster is not on the volume.
_fat_dir_open:
    call    fat_ld32                ;load the start cluster
    ld      hl,0
    call    dir_sdi                 ;open at offset 0
    ld      hl,0
    ret     C                       ;first sector is in fatwin
    inc     l
    ret
