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
; Cluster 0 is the root.
; Call. HL points at the little-endian start cluster.
; Return. L = 0 and H = 0 when the first sector is in the window. Carry is set.
; Return. L = 1 and H = 0 when the cluster is not on the volume or the read fails. Carry is clear.
; Clobber. AF, BC, DE, HL.
_fat_dir_open:
    call    fat_ld32                ;start cluster into BCDE
    ld      hl,0                    ;byte offset 0
    call    dir_sdi                 ;open at the first entry
    ld      hl,0                    ;ld does not change flags
    ret     C                       ;first sector is in the window
    inc     l                       ;L = 1. inc does not change carry.
    ret
